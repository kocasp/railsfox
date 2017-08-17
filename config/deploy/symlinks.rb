namespace :symlinks do
  desc "Make symlinks"
  task :make do
    commands = all_symlinks.map do |from, to|
      "rm -rf #{release_path}/#{to} && \
      ln -s #{shared_path}/#{from} #{release_path}/#{to}"
    end

    run <<-CMD
    cd #{release_path} &&
    #{commands.join(" && ")}
    CMD
  end
end

after 'deploy:update_code', 'symlinks:make'
