service "redis" do
  action :start
end

file_option = proc do
  owner "vagrant"
  group "vagrant"
end

%w(.gitconfig .screenrc .zshrc).each do |name|
  cookbook_file "/home/vagrant/#{name}.default", &file_option

  bash "Copy defualt conf files" do
    not_if { File.exist? "/home/vagrant/#{name}" }
    code "cp /home/vagrant/#{name}.default /home/vagrant/#{name}"
    user "vagrant"
    group "vagrant"
  end
end

file "/home/vagrant/install.sh" do
  action :delete
end

directory "/home/vagrant/.zsh" do
  owner "vagrant"
  group "vagrant"
end

git "/home/vagrant/.zsh/auto-fu" do
  repository "git://github.com/hchbaw/auto-fu.zsh.git"
  action :checkout
  user "vagrant"
  group "vagrant"
end

git "/home/vagrant/.zsh/zsh-completions" do
  repository "git://github.com/zsh-users/zsh-completions.git"
  action :checkout
  user "vagrant"
  group "vagrant"
end
