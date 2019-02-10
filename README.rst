Tdb2
====

Tdb2 is thing.

Platforms
---------

Tdb2 runs on GNU/Linux. Patches that add support for other free software
platforms are welcome. Patches that add support for Windows and macOS are not
welcome, because it is unethical to burden maintainers with the need to test
on non-free platforms.

Building
--------

The only direct dependency is Nix. Install it and run the following command
from the repository root::

    nix-build

This will download all transitive dependencies, including compilers. Then, it
will build the code and documentation.

License
-------

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, but only version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see `<https://www.gnu.org/licenses/>`_.
