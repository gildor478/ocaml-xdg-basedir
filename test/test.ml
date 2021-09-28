(********************************************************************************)
(*  xdg-basedir: XDG basedir location for data/cache/configuration files        *)
(*                                                                              *)
(*  Copyright (C) 2011, OCamlCore SARL                                          *)
(*                                                                              *)
(*  This library is free software; you can redistribute it and/or modify it     *)
(*  under the terms of the GNU Lesser General Public License as published by    *)
(*  the Free Software Foundation; either version 2.1 of the License, or (at     *)
(*  your option) any later version, with the OCaml static compilation           *)
(*  exception.                                                                  *)
(*                                                                              *)
(*  This library is distributed in the hope that it will be useful, but         *)
(*  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  *)
(*  or FITNESS FOR A PARTICULAR PURPOSE. See the file COPYING.txt for more      *)
(*  details.                                                                    *)
(*                                                                              *)
(*  You should have received a copy of the GNU Lesser General Public License    *)
(*  along with this library; if not, write to the Free Software Foundation,     *)
(*  Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA               *)
(********************************************************************************)

open OUnit2
open FileUtil
open FilePath
open XDGBaseDir

let mk_tmpdir () =
  let tmpdir = Filename.temp_file "xdg-basedir" ".dir" in
  rm [ tmpdir ];
  mkdir tmpdir;
  tmpdir

let bracket_xdg_env test_ctxt f =
  let home, sys1, sys2 =
    bracket
      (fun _test_ctxt -> (mk_tmpdir (), mk_tmpdir (), mk_tmpdir ()))
      (fun (dn1, dn2, dn3) _test_ctxt -> rm ~recurse:true [ dn1; dn2; dn3 ])
      test_ctxt
  in
  let mk_fn = make_filename in
  let xdg_env =
    {
      data_home = mk_fn [ home; ".local"; "share" ];
      data_dirs = [ mk_fn [ sys1; "share" ]; mk_fn [ sys2; "share" ] ];
      config_home = mk_fn [ home; ".config" ];
      config_dirs = [ mk_fn [ sys1; "etc" ]; mk_fn [ sys2; "etc" ] ];
      cache_home = mk_fn [ home; ".cache" ];
    }
  in
  f xdg_env

let test_of_vector (nm, user_file, all_files) =
  nm >:: fun test_ctxt ->
  bracket_xdg_env test_ctxt (fun xdg_env ->
      let xdg_env = Some xdg_env in
      let fn = user_file ?xdg_env ?exists:(Some false) "test.data" in
      let assert_all_files ~msg exp =
        assert_equal ~msg ~printer:(String.concat "; ") exp
          (all_files ?xdg_env ?exists:(Some true) "test.data")
      in
      assert_raises ~msg:"user file doesn't exist" Not_found (fun () ->
          user_file ?xdg_env ?exists:(Some true) "test.data");
      assert_all_files ~msg:"nothing" [];
      mkdir_openfile touch fn;
      assert_all_files ~msg:"1 file" [ fn ])

let tests =
  "XDGBaseDir"
  >::: List.map test_of_vector
         [
           ("data_home", Data.user_file, Data.all_files);
           ("config_home", Config.user_file, Config.all_files);
           ( "cache_home",
             Cache.user_file,
             fun ?xdg_env ?exists fn ->
               try [ Cache.user_file ?xdg_env ?exists fn ]
               with Not_found -> [] );
         ]

let () = run_test_tt_main tests
