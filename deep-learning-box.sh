sudo add-apt-repository -y ppa:apt-fast/stable
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get -y install apt-fast
# prompts

sudo apt-fast -y upgrade

sudo apt-fast install -y ubuntu-drivers-common libvorbis-dev libflac-dev libsndfile-dev cmake build-essential libgflags-dev libgoogle-glog-dev libgtest-dev google-mock zlib1g-dev libeigen3-dev libboost-all-dev libasound2-dev libogg-dev libtool libfftw3-dev libbz2-dev liblzma-dev libgoogle-glog0v5 gcc-6 gfortran-6 g++-6 doxygen graphviz libsox-fmt-all parallel exuberant-ctags vim-nox python-powerline python3-pip ack lsyncd
sudo apt-fast install -y tigervnc-standalone-server firefox mesa-common-dev

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6   40 --slave /usr/bin/g++ g++ /usr/bin/g++-6 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-6
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7   40 --slave /usr/bin/g++ g++ /usr/bin/g++-7 --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-7

cd
mkdir Download
cd Download/

wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
# let installer conda init
bash Anaconda3-*.sh 
source ~/.bashrc


# Driver install
#####################################
# should not print anything
lsmod | grep nouveau 

wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
sudo bash cuda_10.1.243_418.87.00_linux.run
echo /usr/local/cuda/lib64 | sudo tee -a /etc/ld.so.conf 
sudo ldconfig
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
source ~/.bashrc


# Did not do this yet
wget http://files.fast.ai/files/cudnn-10.1-linux-x64-v7.6.3.30.tgz
tar xf cudnn-10*.tgz
sudo cp cuda/include/cudnn.h /usr/local/cuda/include
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
sudo ldconfig

#####################################

sudo apt-fast -y install git cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync

conda install -c pytorch -c fastai fastai pytorch

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

# swift stuff below

cd ~/Download/
wget https://storage.googleapis.com/swift-tensorflow-artifacts/nightlies/latest/swift-tensorflow-DEVELOPMENT-cuda10.0-cudnn7-ubuntu18.04.tar.gz
tar xf swift-tensorflow-DEVELOPMENT-cuda10.0-cudnn7-ubuntu18.04.tar.gz
cd
mkdir swift
cd swift
mv ~/Download/usr ./
cd
echo 'export PATH=~/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc


ssh-keygen -t rsa -b 4096 -C "alexsimons9999@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa


mkdir ~/workspace
cd ~/workspace
git clone git@github.com:cyclic-reference/fast-ai-swift.git
git clone git@github.com:cyclic-reference/course-v3.git


git clone https://github.com/google/swift-jupyter.git
cd swift-jupyter
python register.py --sys-prefix --swift-python-use-conda --use-conda-shared-libs   --swift-toolchain ~/swift

cd ~/workspace/course-v3
jupyter notebook --ip=0.0.0.0