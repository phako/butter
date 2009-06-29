/*
 * Copyright (C) 2009 Jens Georg <mail@jensge.org>.
 *
 * Author: Jens Georg <mail@jensge.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 */

public class FilesystemWalker : Object {
    private Queue<File> file_queue;
    private Cancellable cancellable;

    /** Signals */
    public signal void new_file (File file, FileInfo info);

    public signal void finished ();

    public FilesystemWalker () {
        this.file_queue = new Queue<File> ();
    }

    private void on_close_finished (Object source, AsyncResult res) {
        var enumerator = (FileEnumerator) source;

        try {
            enumerator.close_finish (res);
            if (file_queue.get_length () > 0) {
                file_queue.pop_head ();
            }

            if (file_queue.get_length () > 0) {
                var file = file_queue.peek_head ();
                file.enumerate_children_async ("*",
                        FileQueryInfoFlags.NONE,
                        Priority.DEFAULT,
                        this.cancellable,
                        this.on_enumerate_ready);
            }
        } catch (Error error) {
        }
   }

    private void on_next_files_ready (Object source, AsyncResult res) {
        var enumerator = (FileEnumerator) source;

        try {
            var info_list = enumerator.next_files_finish (res);
            if (info_list != null) {
                enumerator.next_files_async (10,
                                             Priority.DEFAULT,
                                             this.cancellable,
                                             this.on_next_files_ready);
                var parent = this.file_queue.peek_head ();
                foreach (var info in info_list) {
                    var current = parent.get_child (info.get_name ());
                    this.new_file (current, info);
                    if (info.get_file_type () == FileType.DIRECTORY) {
                        this.file_queue.push_tail (current);
                    }
                }
            } else {
                enumerator.close_async (Priority.DEFAULT,
                                        this.cancellable,
                                        this.on_close_finished);
            }
        } catch (Error error) {
            warning ("Failed to enumerate");
        }
    }

    private void on_enumerate_ready (Object source, AsyncResult res) {
        var file = (File) source;
            debug ("Walk ready.");

        try {
            var enumerator = file.enumerate_children_finish (res);
            enumerator.next_files_async (10,
                                         Priority.DEFAULT,
                                         this.cancellable,
                                         this.on_next_files_ready);
        } catch (Error error) {
            warning ("Failed to enumerate %s", file.get_uri ());
        }
    }

    public void walk (File file, Cancellable? cancellable = null) {
        debug ("Walk called");
        this.cancellable = cancellable;
        this.file_queue.push_tail (file);

        file.enumerate_children_async ("*",
                                       FileQueryInfoFlags.NONE,
                                       Priority.DEFAULT,
                                       this.cancellable,
                                       this.on_enumerate_ready);
    }
}
