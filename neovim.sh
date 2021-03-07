pip3 install neovim
rm -rf neovim
git clone https://github.com/neovim/neovim.git

# Yeah, this doesn't work. You'd think it would because it says so on the wiki,
# but it fails spectacularly with several steps failing hard.
 cd neovim && make CMAKE_BUILD_TYPE=Release && sudo make install
# First off, we wanna build the deps. This seems to only work when called explicitly
# Why beats me, but hey, whatever floats their boat
# Oh, and all the directories have to be removed in advance, because fuck you, right?
#cd neovim && mkdir -p .deps && cd .deps && cmake ../third-party -DCMAKE_BUILD_TYPE=Release && cmake --build . -j`nproc` && cd ../..
# Then we need to actually build Neovim
#cd neovim && mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && cmake --build . -j`nproc` && sudo make install && cd ../..

rm -rf neovim-qt
sudo apt install qt5-default libqt5svg5-dev
# Then we clone the GUI...
git clone https://github.com/equalsraf/neovim-qt
# And build that crap
cd neovim-qt && git pull && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . -j`nproc` && sudo make install && cd ../..

