return {
  "uhs-robert/sshfs.nvim",
  opts = {
    connections = {
      sshfs_options = {
        ConnectTimeout = 5,
        reconnect = true,
        ServerAliveCountMax = 3,
        ServerAliveInterval = 15,

        compression = "yes",
        dcache_max_size = 10000,
        dcache_timeout = 300,
        dir_cache = "yes",
      },
    },
    ui = {
      local_picker = {
        preferred_picker = "telescope",
      },
      remote_picker = {
        preferred_picker = "telescope",
      },
    },
  },
}
