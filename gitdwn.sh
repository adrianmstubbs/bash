#!/bin/bash
# use after installation custom packages
#+ base and base-devel
 
 ## create proper file system domain and range within home
 git clone https://git.suckless.org/dwm
 ##  dwm base
 git clone https://git.suckless.org/st
 ##  st base
 git clone git://git.2f30.org/sdhcp.git
 ##  suckless dhcp client
 git clone git://r-36.net/nldev
 ##  nldev lightweight frontend for mdev
 git clone git://r-36.net/svc
 ##  Simple service scripts to be used everywhere
 git clone git://r-36.net/sweb
 ##  Web helper service scripts
 git clone git://r-36.net/wiki 
 ##  personal commandline wiki
 git clone git://r-36.net/rohrpost
 ##  command line mail client
  #  either replace or combine with mutt
 git clone git://r-36.net/svc
 ## service scripts
 git clone git://r-36.net/conn
 ## script repository manage connections linux
 git clone git://r-36.net/dwmstatus
 ##  dwm status bar
 git clone git://git.suckless.org/sbase
 ##  suckless base. base programs
 git clone git://git.musl-libc.org/musl
 ##  musl library
 ##  ircc client
 git clone git://r-36.net/ircc
 ##  ircc clients
 git clone git://git.2f30.org/fs.git
 ## initscripts
 git clone git://r-36.net/yt
 ## description 'youtube like a pro'
 ############ wget the following #########
 ###### apply patches before reboot #######
 #####  bash script for availability
 ## download to dwm and st folder respectively 
 # dwm 
 # dwm-cmdcustomize-20180504-3bd8466.diff
 	wget https://dwm.suckless.org/patches/cmdcustomize/dwm-cmdcustomize-20180504-3bd8466.diff
## dwm-noborder-6.1.diff
 	wget https://dwm.suckless.org/patches/cmdcustomize/dwm-cmdcustomize-20180504-3bd8466.diff
## dwm-r1615-mpdcontrol.diff
 	wget https://dwm.suckless.org/patches/cmdcustomize/dwm-cmdcustomize-20180504-3bd8466.diff
## dwm-6.0-singularborders.diff
 	wget dwm.suckless.org/patches/singularborders/dwm-6.0-singularborders.diff
## dwm-fakefullscreen-20170508-ceac8c9.diff
 	wget dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20170508-ceac8c9.diff
## dwm-moveresize
	wget dwm.suckless.org/patches/moveresize/dwm-moveresize-20160731-56a31dc.diff
##dwm-cropwindows 
	wget dwm.suckless.org/patches/cropwindows/dwm-cropwindows-20170709-ceac8c9.diff
##dwm-autoresize
	wget dwm.suckless.org/patches/autoresize/dwm-autoresize-20160718-56a31dc.diff
##dwm-fancybar
	wget dwm.suckless.org/patches/fancybar/dwm-fancybar-2019018-b69c870.diff

 # st
 # st-anysize-0.8.1.diff
 	wget st.suckless.org/patches/anysize/st-anysize-0.8.1.diff
 # st-bold-is-not-bright-20190127-3be4cf1.diff
 	wget st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff
 # st-clipboard-20180309-c5ba9c0.diff
 	wget st.suckless.org/patches/clipboard/st-clipboard-20180309-c5ba9c0.diff
 # st-font2-20190416-ba72400.diff
 	wget st.suckless.org/patches/font2/st-font2-20190416-ba72400.diff
 # st-scrollback-20190331-21367a0.diff
 	wget st.suckless.org/patches/scrollback/st-scrollback-20190331-21367a0.diff
	## mouse scrolling 
	wget st.suckless.org/patches/scrollback/st-scrollback-mouse-0.8.2.diff
 # st-themed_cursor-0.8.1.diff
 	wget st.suckless.org/patches/themed_cursor/st-themed_cursor-0.8.1.diff
 # st-vertcenter-20180320-6ac8c8a.diff
 	wget st.suckless.org/patches/vertcenter/st-vertcenter-20180320-6ac8c8a.diff
 # st-xresources-20190105-3be4cf1.diff
	wget st.suckless.org/patches/xresources/st-xresources-20190105-3be4cf1.diff
 # st-palettes
 	wget https://st.suckless.org/patches/palettes/st-color_schemes-0.8.1.diff
 # st-relativeborder
 	wget https://st.suckless.org/patches/relativeborder/st-relativeborder-20171207-0ac685f.diff
 # st-deletekey
 	wget https://st.suckless.org/patches/delkey/st-delkey-20160727-308bfbf.diff
 # st-opencopied 
 	wget https://st.suckless.org/patches/open_copied_url/st-openclipboard-20190202-3be4cf1.diff
 # core
 # git clone git://git.2f30.org/sdhcp.git
 # 
 

