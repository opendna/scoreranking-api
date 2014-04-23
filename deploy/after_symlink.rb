info "create symlink for shards.yml"
run! "ln -nfs #{config.shared_path}/config/shards.yml #{config.release_path}/config/shards.yml"
info "create symlink for shards.yml, done!"