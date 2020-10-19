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

(** XDG basedir implementation
  
    The XDG basedir specification makes clear where to store configuration, cache 
    and data files. This a way to maintain a clean $HOME. Locations can be
    customized through environment variables (XDG_DATA_HOME, XDG_CONFIG_HOME). It 
    also allows to store files in several places (i.e. system directories).

    @author Sylvain Le Gall
    @see <http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html> 
         XDG base specification
  *)

(** {2 Types} *)

type filename = string
type dirname = string
type dirnames = dirname list

(** XDG environment *)
type t = 
    {
      data_home :   dirname;  (** $HOME/.local/share *)
      data_dirs :   dirnames; (** /usr/share *)
      config_home : dirname;  (** $HOME/.config *)
      config_dirs : dirnames; (** /etc/xdg *)
      cache_home :  dirname;  (** $HOME/.cache *)
    }

(** {2 Modules and functions} *)

(** Default XDG environment *)
val default : t

(** [mkdir_openfile f fn] Create parent directory of [fn] and 
    apply [f fn]
  *)
val mkdir_openfile : (filename -> 'a) -> filename -> 'a

module Data :
  sig
    (** In this module, [~xdg_env] allows to override the default
        XDG environment. If you use [~exists:true], the files/dirs
        are tested for existence.
      *)
       
    (** Get the user-specific data directory. *)
    val user_dir : 
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname

    (** Get a list of all system-specific data directories. *)
    val system_dirs :
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname list

    (** Get a list of all data directories. *)
    val all_dirs : 
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname list

    (** Get the user-specific filename for a data file. *) 
    val user_file :
      ?xdg_env:t -> 
      ?exists:bool -> filename -> filename

    (** Get the list of system-specific filenames for a data file. *) 
    val system_files :
      ?xdg_env:t ->
      ?exists:bool -> filename -> filename list

    (** Get the list of all filenames for a specific data file. *) 
    val all_files :
      ?xdg_env:t ->
      ?exists:bool -> filename -> filename list
  end

module Config :
  sig
    (** See {!Data} for explanations about [~xdg_env] and [~exists] *)

    (** Get the user-specific configuration directory. *)
    val user_dir : 
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname

    (** Get a list of all system-specific configuration directories. *)
    val system_dirs :
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname list

    (** Get a list of all configuration directories. *)
    val all_dirs : 
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname list

    (** Get the user-specific filename for a configuration file. *) 
    val user_file :
      ?xdg_env:t -> 
      ?exists:bool -> filename -> filename

    (** Get the list of system-specific filenames for a configuration file. *) 
    val system_files :
      ?xdg_env:t ->
      ?exists:bool -> filename -> filename list

    (** Get the list of all filenames for a specific configuration file. *) 
    val all_files :
      ?xdg_env:t ->
      ?exists:bool -> filename -> filename list
  end

module Cache :
  sig
    (** See {!Data} for explanations about [~xdg_env] and [~exists] *)

    (** Get the user-specific cache directory. *)
    val user_dir : 
      ?xdg_env:t -> 
      ?exists:bool -> unit -> dirname

    (** Get the user-specific filename for a cache file. *) 
    val user_file :
      ?xdg_env:t -> 
      ?exists:bool -> filename -> filename
  end

