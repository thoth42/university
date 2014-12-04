#!/bin/bash
SESSION=$USER

tmux -2 new-session -d -s $SESSION

# Setup a window for connection other
tmux new-window -t $SESSION:1 -n 'Servers(2,3)'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "ruby main_server.rb" C-m
sleep 3
tmux select-pane -t 1
tmux send-keys "ruby server.rb --port 10001" C-m
tmux select-pane -t 0

# Setup the comunication
tmux new-window -t $SESSION:2 -n 'Servers(1)'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "ruby server.rb  --port 10002" C-m
tmux select-pane -t 1
tmux send-keys "ruby server.rb" C-m
tmux select-pane -t 0

tmux new-window -t $SESSION:3 -n 'Client'
sleep 4
tmux send-keys "ruby client.rb" C-m

# Set default window
tmux select-window -t $SESSION:3

# Attach to session
tmux -2 attach-session -t $SESSION
