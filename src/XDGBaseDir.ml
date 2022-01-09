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

(** XDG basedir specification
    @author Sylvain Le Gall
  *)

open FilePath
open Unix

type filename = string
type dirname = string
type dirnames = dirname list

type t = {
  data_home : dirname;
  data_dirs : dirnames;
  config_home : dirname;
  config_dirs : dirnames;
  cache_home : dirname;
}

let default =
  let not_found default var =
    try default ()
    with Not_found ->
      failwith (Printf.sprintf "Environment variable '%s' not defined" var)
  in

  let getenv ?(default = fun () -> raise Not_found) var =
    match Sys.getenv var with
    | exception Not_found -> not_found default var
    | "" -> not_found default var
    | var -> var
  in

  let home = getenv "HOME" ~default:(fun () -> (getpwuid (getuid ())).pw_dir) in

  let mk_var_gen f env win32 unix =
    let lst = if Sys.os_type = "Win32" then win32 else unix in
    getenv ~default:(fun () -> f (Lazy.force lst)) env
  in

  let mk_var = mk_var_gen make_filename in

  let mk_var_path env win32 unix =
    path_of_string (mk_var_gen (fun s -> s) env win32 unix)
  in

  {
    data_home =
      mk_var "XDG_DATA_HOME"
        (lazy [ getenv "AppData" ])
        (lazy [ home; ".local"; "share" ]);
    data_dirs =
      mk_var_path "XDG_DATA_DIRS"
        (lazy (getenv "ProgramFiles"))
        (lazy "/usr/local/share:/usr/share");
    config_home =
      mk_var "XDG_CONFIG_HOME"
        (lazy [ home; "Local Settings" ])
        (lazy [ home; ".config" ]);
    config_dirs =
      mk_var_path "XDG_CONFIG_DIRS"
        (lazy (getenv "ProgramFiles"))
        (lazy "/etc/xdg");
    cache_home =
      mk_var "XDG_CACHE_HOME"
        (lazy [ home; "Local Settings"; "Cache" ])
        (lazy [ home; ".cache" ]);
  }

let dir_exists ?(exists = false) dn =
  (not exists) || (Sys.file_exists dn && Sys.is_directory dn)

let file_exists ?(exists = false) fn = (not exists) || Sys.file_exists fn

let mk_fun data test comb =
  let filter_comb lst ?exists a =
    List.fold_right
      (fun fn acc ->
        let fn' = comb fn a in
        if test ?exists fn' then fn' :: acc else acc)
      lst []
  in

  let user_dir ?(xdg_env = default) ?exists a =
    let home, _ = data xdg_env in
    let fn = comb home a in
    if test ?exists fn then fn else raise Not_found
  in

  let system_dirs ?(xdg_env = default) =
    let _, system = data xdg_env in
    filter_comb system
  in

  let all_dirs ?(xdg_env = default) =
    let home, system = data xdg_env in
    filter_comb (home :: system)
  in

  (user_dir, system_dirs, all_dirs)

module Make (E : sig
  val data : t -> dirname * dirname list
end) =
struct
  let user_dir, system_dirs, all_dirs =
    mk_fun E.data dir_exists (fun fn () -> fn)

  let user_file, system_files, all_files =
    mk_fun E.data file_exists FilePath.concat
end

module Data = Make (struct
  let data t = (t.data_home, t.data_dirs)
end)

module Config = Make (struct
  let data t = (t.config_home, t.config_dirs)
end)

module Cache = struct
  let user_dir ?(xdg_env = default) ?exists () =
    let dn = xdg_env.cache_home in
    if dir_exists ?exists dn then dn else raise Not_found

  let user_file ?xdg_env ?exists fn =
    let fn' = FilePath.concat (user_dir ?exists ?xdg_env ()) fn in
    if file_exists ?exists fn' then fn' else raise Not_found
end

let mkdir_openfile file_open fn =
  let dn = dirname fn in
  FileUtil.mkdir ~parent:true dn;
  file_open fn
