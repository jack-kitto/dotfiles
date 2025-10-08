# 🌱 Universal Developer Environment — Jack Kitto

A complete, **cross‑platform reproducible development environment** leveraging:

- **Dotfiles + scripts** — configuration, identity, and automation  
- **Devbox + Nix** — isolated toolchains per project  
- **Toolbox / Distrobox** — optional mutable sandbox layer on Linux  
- **Homebrew / DNF parity** — shared CLI tool baseline across macOS and Linux  
- **LazyVim + tmux** — unified terminal workflow  
- **Secrets repo** — private SSH / GPG keys and GitHub auth imported automatically  

The goal:  
> Clone this repo → run one command → get a full, signed, authenticated, ready‑to‑code environment on macOS, Linux, or WSL.

---

## 🧩 Architecture Overview

| Layer | Purpose | Technology |
|-------|----------|-------------|
| **Host OS** | Base system (macOS / Linux / WSL) | Homebrew / DNF / APT |
| **Toolbox / Distrobox** *(Linux)* | Mutable dev container on any distro | Fedora Toolbox or Distrobox |
| **Devbox** | Reproducible project‑specific toolchain | Nix + Devbox |
| **Dotfiles repo (this)** | Environment source of truth | Git |
| **Secrets repo** | Encrypted identity & credentials | [jack‑kitto/secrets‑repo](https://github.com/jack-kitto/secrets-repo) |

---

## 🧠 Philosophy

1. **Declarative** — Everything lives as code in Git.  
2. **Portable** — Runs identically on macOS, any Linux distro, or WSL on Windows.  
3. **Isolated** — Each project → its own Devbox.  
4. **Secure** — GPG‑encrypted secrets and SSH identities handled automatically.

---

## 📦 Components

### 🧱 Dotfiles
Personal configs for:
- `tmux`, `neovim` (LazyVim), `git`, `ssh`, `gh`, `zsh`, etc.  
Symlinked into `~/.config` by `bootstrap/link_configs.sh`.

### 🧰 Toolbox / Distrobox (Linux optional)
Mutable Fedora or Ubuntu container used when host OS is read‑only or you want a clean dev sandbox.

### 📦 Devbox
Per‑project reproducible environments using Nix.  
Templates (in `devbox-templates/`) provide your base stack.

### 🍺 Homebrew (DNF / APT)
Baseline CLI tooling defined once in `homebrew/Brewfile`.  
macOS uses Homebrew; Linux parses the same list into DNF or APT.

### 🔐 Secrets Repo
Contains your private materials:
- SSH key‑pairs (one per identity)
- GPG keys for commit signing
- GitHub CLI auth config  

Imported automatically through `bootstrap/import_keys.sh`.

---

## ⚙️ Setup Flow

1. **Clone this repo**
   ```bash
   git clone --recurse-submodules https://github.com/jack-kitto/dotfiles ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the bootstrap**
   ```bash
   bash setup.sh
   ```

   The script:
   - Detects host OS  
   - Installs Nix and Devbox (and Toolbox on Linux if desired)  
   - Imports keys and configures Git identities  
   - Links configs (`tmux`, `nvim`, etc.)  
   - Sets up a `~/code` workspace  

3. **Start coding**
   ```bash
   cd ~/code
   git clone git@github.com:<user>/<project>.git
   cd <project>
   devbox shell
   ```

You now have an isolated Devbox environment + your base dotfiles on top.

---

## 🧩 Multi‑Identity Support

- Separate SSH keys and GitHub accounts configured in `configs/ssh/config`  
- Per‑company or per‑project Git identities via Git `includeIf`  
- Multiple GPG keys for signed commits (imported from `secrets-repo`)  

Handled automatically by `bootstrap/setup_git_identity.sh`.

---

## 📁 Repository Layout

```
dotfiles/
├── README.md
├── setup.sh
├── configs/
│   ├── tmux/
│   ├── nvim/            # LazyVim configuration
│   ├── git/
│   ├── ssh/
│   ├── gh/
│   └── gpg/
├── bootstrap/
│   ├── install_nix.sh
│   ├── install_devbox.sh
│   ├── import_keys.sh
│   ├── setup_git_identity.sh
│   ├── link_configs.sh
│   ├── setup_code_dir.sh
│   └── import_brewfile.sh
├── devbox-templates/
│   └── base/devbox.json
├── homebrew/
│   └── Brewfile
├── toolboxes/
│   ├── dev.Containerfile
│   └── create-dev.sh
└── secrets-repo/ (submodule)
```

---

## 🔁 Workflow Summary

| OS | Command | Result |
|----|----------|--------|
| macOS | `bash setup.sh` | Homebrew + Devbox + dotfiles + secrets |
| Linux | `bash setup.sh` | Toolbox/Distrobox + Devbox + dotfiles + secrets |
| Windows (WSL2) | `bash setup.sh` | works identically to Linux |

---

## 💡 Start a New Project

```bash
cd ~/code
git clone git@github.com-company-a:company-a/newapp.git
cd newapp
devbox init --template ~/.dotfiles/devbox-templates/base
devbox add nodejs@20 typescript
devbox shell
```

→ automatic tmux session + LazyVim inside isolated stack.

---

## ✅ Maintenance

| Action | Command |
|---------|----------|
| Update CLI tools | `brew upgrade` / `devbox update` |
| Sync configs | `git -p pull origin main && bash setup.sh` |
| Add new packages | Edit `homebrew/Brewfile` (→ auto‑import into Toolbox) |

---

## 🧠 Philosophy Recap

> **Everything is code**  
> Packages, toolchains, configs, identities, and secrets are all version‑controlled and reproducible from a single repository.

---

## 🛠 Future Ideas
- Docker/Podman CI containers
- Cloud Devbox remotes
- Automatic SSH/Tailscale provisioning

---

© 2025 Jack Kitto — All Rights Reserved
