FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# Installing ROS
RUN sudo apt-get update && sudo apt-get -y upgrade wget git nano
RUN wget https://raw.githubusercontent.com/ROBOTIS-GIT/robotis_tools/master/install_ros_kinetic.sh
RUN chmod 755 ./install_ros_kinetic.sh 
RUN bash ./install_ros_kinetic.sh
RUN sudo apt-get install -y ros-kinetic-joy ros-kinetic-teleop-twist-joy ros-kinetic-teleop-twist-keyboard ros-kinetic-laser-proc  ros-kinetic-rgbd-launch ros-kinetic-depthimage-to-laserscan  ros-kinetic-rosserial-arduino ros-kinetic-rosserial-python  ros-kinetic-rosserial-server ros-kinetic-rosserial-client  ros-kinetic-rosserial-msgs ros-kinetic-amcl ros-kinetic-map-server  ros-kinetic-move-base ros-kinetic-urdf ros-kinetic-xacro  ros-kinetic-compressed-image-transport ros-kinetic-rqt-image-view  ros-kinetic-gmapping ros-kinetic-navigation ros-kinetic-interactive-markers
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"
RUN sudo apt-get install -y ros-kinetic-turtlebot3-msgs
RUN sudo apt-get install -y ros-kinetic-turtlebot3

# Update Gazebo 9
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

RUN apt-get update && apt-get install -y ros-kinetic-gazebo9-ros-pkgs ros-kinetic-gazebo9-ros-control ros-kinetic-gazebo9*
RUN apt-get install -y ros-kinetic-catkin rviz
RUN apt-get install -y ros-kinetic-controller-manager ros-kinetic-joint-state-controller ros-kinetic-joint-trajectory-controller ros-kinetic-rqt ros-kinetic-rqt-controller-manager ros-kinetic-rqt-joint-trajectory-controller ros-kinetic-ros-control ros-kinetic-rqt-gui
RUN apt-get install -y ros-kinetic-rqt-plot ros-kinetic-rqt-graph ros-kinetic-rqt-rviz ros-kinetic-rqt-tf-tree
RUN apt-get install -y ros-kinetic-gazebo9-ros ros-kinetic-kdl-conversions ros-kinetic-kdl-parser ros-kinetic-forward-command-controller ros-kinetic-tf-conversions ros-kinetic-xacro ros-kinetic-joint-state-publisher ros-kinetic-robot-state-publisher
RUN apt-get install -y ros-kinetic-ros-control ros-kinetic-ros-controllers

# Write .bashrc file
# RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc"
RUN /bin/bash -c "echo 'export TURTLEBOT3_MODEL=waffle_pi' >> /root/.bashrc && source /root/.bashrc"

# clone pakages of ros1 and machine learning
WORKDIR "/home/ubuntu/catkin_ws/src/"
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN git clone -b kinetic-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
RUN git clone https://github.com/ROBOTIS-GIT/turtlebot3_machine_learning.git


# Install python-pip and pakages
RUN sudo apt install -y python-pip
RUN /bin/bash -c "pip install --upgrade pip;pip install --ignore-installed --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.8.0-cp27-none-linux_x86_64.whl;pip install keras==2.1.5;pip install Werkzeug==0.16.1;pip install h5py;pip install pyqtgraph==0.11.0"

# Installing Atom Editor
RUN add-apt-repository ppa:webupd8team/atom && apt update && apt install -y atom

RUN sudo apt-get update && sudo apt-get -y upgrade

# Build pakages
RUN /bin/bash -c "source /root/.bashrc"
WORKDIR "/home/ubuntu/catkin_ws/"
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd catkin_ws; catkin_make'
