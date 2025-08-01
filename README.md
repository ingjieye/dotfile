# My Dotfiles

This repository contains my personal dotfiles for various tools like Neovim, tmux, and zsh. It is designed to be easily deployable on new systems, primarily macOS and Linux.

## Features

-   **Automated Setup**: Includes an installation script (`install.sh`) to set up essential tools and dependencies using Homebrew on macOS and `apt` on Ubuntu.
-   **Symbolic/Hard Linking**: The `deploy.sh` script intelligently creates symbolic links (or hard links for specified files) from the repository to your home directory.
-   **Cross-platform**: Primarily supports macOS and Linux (Ubuntu).
-   **Customizable**: Easily extendable and customizable by adding new configuration files or modifying existing ones.

## Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/ingjieye/dotfile.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2.  **Run the installation script:**

    This script will install necessary packages. It supports macOS and Ubuntu.

    ```bash
    ./install.sh
    ```

3.  **Deploy the dotfiles:**

    This will create symbolic links for your configuration files in your home directory.

    ```bash
    ./deploy.sh
    ```

## Structure

-   `install.sh`: Installs dependencies like Neovim, tmux, fzf, etc.
-   `deploy.sh`: Deploys the configuration files by creating symlinks.
-   `.vimrc`, `.zshrc`, `.tmux.conf`: Configuration files for Vim/Neovim, Zsh, and tmux.
-   `.config/`: Contains configurations for applications like `nvim`.
-   `.dothardlink`: A list of files to be hard-linked instead of soft-linked.
-   `.dotignore`: A list of files to be ignored by the `deploy.sh` script.

## Customization

To add your own configurations:

1.  Place your configuration file in the repository.
2.  If you don't want to deploy it, add its name to `.dotignore`.
3.  If you want it to be hard-linked, add its name to `.dothardlink`.
4.  Run `./deploy.sh` again.

## Inspirations

This configuration is deeply inspired by [MaskRay/Config](https://github.com/MaskRay/Config).
