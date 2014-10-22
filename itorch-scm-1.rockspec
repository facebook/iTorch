package = "itorch"
version = "scm-1"

source = {
   url = "git://github.com/soumith/iTorch.git",
}

description = {
   summary = "iPython kernel for Lua / Torch",
   detailed = [[
   ]],
   homepage = "https://github.com/soumith/iTorch",
   license = "BSD"
}

dependencies = {
   "torch >= 7.0",
   "trepl",
   "penlight",
   "lua-cjson",
   "uuid"
   -- "lzmq == scm"
}

build = {
   type = "command",
   build_command = [[
   ipy=$(which ipython)
   if [ -x "$ipy" ]
   then
	rm -rf ~/.ipython/profile_torch
	ipython profile create torch
	echo 'c.KernelManager.kernel_cmd = ["$(LUA_BINDIR)/itorch_launcher","{connection_file}"]' >>~/.ipython/profile_torch/ipython_config.py   	
	echo "c.Session.key = b''" >>~/.ipython/profile_torch/ipython_config.py
	echo "c.Session.keyfile = b''" >>~/.ipython/profile_torch/ipython_config.py
	cp itorch $(LUA_BINDIR)/
	cp itorch_launcher $(LUA_BINDIR)/
	cmake -E make_directory build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)" && $(MAKE)	
   else
	echo "Error: could not find ipython in PATH. Do you have it installed?"
   fi
  
]],
   install_command = "cd build && $(MAKE) install"
}