# elementary post install

My post install script, based on Sam Hewitt's [ubuntu-post-install](https://github.com/snwh/ubuntu-post-install). It should work on Ubuntu and its derivates.

## Configuration 

 * [`data/apps`](/data/apps): functions for installing all applications.
 * [`data/dotfiles`](/data/dotfiles): configuration file for installing your own dotfiles. You need a Git repository with an `install.sh` script.
 * [`data/everything`](/data/everything): function for the full installation. Comment and uncomment the apps you want or don't want to install.

## Usage

    git clone https://github.com/drieiro/post-install.git
    cd post-install
    ./post-install
