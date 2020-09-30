-- NOTE: see https://github.com/Tarrasch/antigen-hs
-- BUG: broken due to https://github.com/Tarrasch/antigen-hs/issues/23
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
module MyAntigen where


import Antigen (AntigenConfig (..)
              , defaultConfig
              , bundle
              , antigen
              , antigenSourcingStrategy
              , filePathsSourcingStrategy
              , local
              , ZshPlugin(..)
              , )

bundles =
  [
  -- bundle "Tarrasch/zsh-functional"
  -- , bundle "Tarrasch/zsh-bd"
  -- , bundle "Tarrasch/zsh-command-not-found"
  -- , bundle "Tarrasch/zsh-colors"
  -- , bundle "Tarrasch/zsh-autoenv"
  -- , bundle "Tarrasch/zsh-i-know"
  -- , bundle "Tarrasch/pure"
  -- , bundle "Tarrasch/zsh-mcd"
  -- , bundle "zsh-users/zsh-syntax-highlighting"
  -- , bundle "zsh-users/zsh-history-substring-search"
  (bundle "robbyrussell/oh-my-zsh")
    {
      sourcingLocations = [
        "plugins/extract",
        "plugins/cp",
        "plugins/sublime",
        "plugins/pyenv",
        "plugins/autojump",
        "plugins/fzf",
        "plugins/colored-man-pages",
        "plugins/safe-paste"
      ]
    },
    (bundle "robbyrussell/oh-my-zsh")
    {
      sourcingStrategy = filePathsSourcingStrategy
        [
          "plugins/docker/_docker",
          "plugins/fd/_fd",
          "plugins/redis-cli/_redis-cli",
          "plugins/nomad/_nomad"
        ]
    },
    (bundle "robbyrussell/oh-my-zsh")
    {
      sourcingStrategy = antigenSourcingStrategy,
      sourcingLocations = []
    }
  ]


config = defaultConfig { plugins = bundles }

main :: IO ()
main = antigen config
