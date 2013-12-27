bash "install-ghc" do
  not_if { File.exist? "/usr/local/haskell/bin/ghc" }
  notifies :run, "bash[install-haskell-platform]"

  user "root"
  cwd "/tmp"
  code <<EOS
  wget http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2
  tar -vjxf ghc-7.6.3-x86_64-unknown-linux.tar.bz2
  cd ghc-7.6.3
  ./configure --prefix=/usr/local/haskell
  make install
  cd -
  rm -rf ghc-7.6.3
  rm ghc-7.6.3-x86_64-unknown-linux.tar.bz2
EOS
end

bash "install-haskell-platform" do
  action :nothing
  notifies :run, "bash[cabal-update]"

  user "root"
  cwd "/tmp"
  path ["/usr/local/haskell/bin"]
  code <<EOS
  wget http://www.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz
  tar -zxvf haskell-platform-2013.2.0.0.tar.gz
  cd haskell-platform-2013.2.0.0
  ./configure --prefix=/usr/local/haskell
  make
  make install
  cd -
  rm haskell-platform-2013.2.0.0.tar.gz
  rm -rf haskell-platform-2013.2.0.0
EOS
end

bash "cabal-update" do
  action :nothing
  user "vagrant"
  cwd "/home/vagrant"
  environment "HOME" => "/home/vagrant"
  path ["/usr/local/haskell/bin"]
  code "cabal update && cabal install cabal-install"
end
