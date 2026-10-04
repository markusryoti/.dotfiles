# Dotfiles

Tracked with a bare git repo: the git directory lives in `~/.dotfiles` and the
work tree is `$HOME`, so files stay in their normal locations — no symlinks.

Currently tracked:

- Neovim (`~/.config/nvim`)
- k9s (`~/.config/k9s`) — aliases, Catppuccin skins ([catppuccin/k9s](https://github.com/catppuccin/k9s))
- lazygit (`~/.config/lazygit`) — Catppuccin Mocha theme

## Daily use

The `dot` alias replaces `git` for this repo:

```bash
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

```bash
dot status                      # only shows tracked files
dot add ~/.config/nvim          # stage changes
dot commit -m "message"
dot push
```

Untracked files are hidden (`status.showUntrackedFiles no`), so new files are
never picked up automatically — add them explicitly:

```bash
dot add ~/.zshrc ~/.config/lazygit
dot ls-files                    # list everything tracked
```

## Set up on a new machine

```bash
# 1. Clone as a bare repo
git clone --bare git@github-personal:markusryoti/.dotfiles.git ~/.dotfiles

# 2. Define the alias for this shell
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 3. Check out files into $HOME
#    If it fails because files already exist, back them up / remove them first.
dot checkout

# 4. Hide untracked files and set the commit identity for this repo
dot config status.showUntrackedFiles no
dot config user.name "markusryoti"
dot config user.email mryoti@gmail.com

# 5. Make the alias permanent
echo "alias dot='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'" >> ~/.zshrc
```

`github-personal` is an SSH host alias in `~/.ssh/config` pointing to
`github.com` with the personal key. Use `git@github.com:markusryoti/.dotfiles.git`
if that alias isn't set up.

## Notes

- macOS: k9s and lazygit only read `~/.config` when `XDG_CONFIG_HOME` is set
  (`export XDG_CONFIG_HOME=$HOME/.config` in `~/.zshrc`); otherwise they use
  `~/Library/Application Support`.
