info "create symlink for shards.yml"
run! "ln -nfs #{shared_path}/config/shards.yml #{release_path}/config/shards.yml"
info "create symlink for shards.yml, done!"