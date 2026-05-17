hl.layer_rule({ blur = true })

hl.layer_rule({
  name = "no-screen-share-notifications",
  match = { namespace = "^(notifications)$" },
  no_screen_share = true,
})

hl.layer_rule({
  name = "no-screen-share-rofi",
  match = { namespace = "^(rofi)$" },
  no_screen_share = true,
})

hl.layer_rule({
  name = "no-screen-share-walker",
  match = { namespace = "^(walker)$" },
  no_screen_share = true,
})
