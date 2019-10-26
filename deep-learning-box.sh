sudo add-apt-repository -y ppa:apt-fast/stable
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get -y install apt-fast
# prompts

sudo apt-fast -y upgrade

sudo apt-fast install -y ubuntu-drivers-common libvorbis-dev libflac-dev libsndfile-dev cmake build-essential libgflags-dev libgoogle-glog-dev libgtest-dev google-mock zlib1g-dev libeigen3-dev libboost-all-dev libasound2-dev libogg-dev libtool libfftw3-dev libbz2-dev liblzma-dev libgoogle-glog0v5 gcc-6 gfortran-6 g++-6 doxygen graphviz libsox-fmt-all parallel exuberant-ctags vim-nox python-powerline python3-pip ack lsyncd

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6   40 --slave /usr/bin/g++ g++ /usr/bin/g++-6 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7   40 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-7

sudo apt-fast -y install git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync

sudo apt install zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cat << 'EOF' >> ~/.bashrc
export SHELL=/bin/zsh
exec /bin/zsh -l
EOF
source ~/.bashrc
cat << 'EOF' >> ~/.zshrc
alias ll="ls -la"
alias gs="git status"
alias gps="git push"
alias gcm="git commit -a -m "
alias gpm="git pull origin master"
alias ga="git add -A ."
alias gp="git pull"
alias gc="git checkout"
alias gl="git log -n"
alias gst="git stash"
alias chrome-broke="rm -r ~/.config/google-chrome/*"
alias yi="yarn install"
alias ys="yarn start"
alias yeet="yarn test -u"
alias yt="yarn test"
alias dc="docker-compose"
alias dcl="docker-compose logs -f"

alias tarUnzip="tar -xvzf"
alias dcd="docker-compose -f docker-compose-dev.yml"
EOF

# Custom ZSH Stuff (too lazy to write script to put these in.)
#ZSH_THEME="norm"
#plugins=(git zsh-autosuggestions zsh-syntax-highlighting colored-man-pages colorize lol aws)

# Restart


cd
mkdir Downloads
cd Downloads/

# Driver install
#####################################

# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-fast update
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-fast update

# Install NVIDIA driver
sudo apt-fast install --no-install-recommends nvidia-driver-418
# Reboot. Check that GPUs are visible using the command: nvidia-smi

# Install development and runtime libraries (~4GB)
sudo apt-fast install --no-install-recommends \
    cuda-10-0 \
    libcudnn7=7.6.2.24-1+cuda10.0  \
    libcudnn7-dev=7.6.2.24-1+cuda10.0


# Install TensorRT. Requires that libcudnn7 is installed above.
sudo apt-fast install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda10.0 \
    libnvinfer-dev=5.1.5-1+cuda10.0

#####################################

wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
# let installer run cconda init
zsh Anaconda3-*.sh 
source ~/.zshrc

conda create -n swift-env python=3.6
conda activate swift-env
conda install jupyter numpy matplotlib


# swift stuff below
wget https://storage.googleapis.com/swift-tensorflow-artifacts/releases/v0.4/rc4/swift-tensorflow-RELEASE-0.4-cuda10.0-cudnn7-ubuntu18.04.tar.gz
tar xf swift-tensorflow-RELEASE-*
mkdir ~/swift
mv usr/ ~/swift/
echo 'export PATH=~/swift/usr/bin:$PATH' >> ~/.zshrc
source ~/.zshrc


ssh-keygen -t rsa -b 4096 -C "alexsimons9999@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

mkdir ~/workspace
cd ~/workspace
git clone git@github.com:cyclic-reference/fast-ai-swift.git
git clone git@github.com:cyclic-reference/course-v3.git


git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
source ~/.zshrc


jupyter notebook --generate-config
cat << 'EOF' >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.open_browser = False
c.NotebookApp.token = ''
EOF

pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
jupyter nbextension enable collapsible_headings/main
mkdir ~/.jupyter/custom
echo '.container { width: 99% !important; }' > ~/.jupyter/custom/custom.css

git clone https://github.com/google/swift-jupyter.git
cd swift-jupyter
python register.py --sys-prefix --swift-python-use-conda --use-conda-shared-libs   --swift-toolchain ~/swift

cd ~/workspace/
# Make sure that the conda (swift-env) is active 
nohup jupyter notebook --ip=0.0.0.0 > jupyter.log & 
