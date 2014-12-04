#!/bin/bash
SESSION=$USER

tmux -2 new-session -d -s $SESSION

# run main server and a ordinary server
tmux new-window -t $SESSION:1 -n 'Servers(1,2)'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "ruby main_server.rb" C-m
sleep 2
tmux select-pane -t 1
tmux send-keys "ruby server.rb --port 10001 --file data_010.json" C-m
tmux select-pane -t 0

# Start server 3 and 4 with json data
tmux new-window -t $SESSION:2 -n 'Servers(3,4)'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "ruby server.rb  --port 10002 --file data_020.json" C-m
tmux select-pane -t 1
tmux send-keys "ruby server.rb  --port 10003 --file data_030.json" C-m
tmux select-pane -t 0

#start server 5 and 6 with xml data
tmux new-window -t $SESSION:3 -n 'Servers(5,6)'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "ruby server.rb  --port 10004 --file data_010.xml" C-m
tmux select-pane -t 1
tmux send-keys "ruby server.rb  --port 10005 --file data_020.xml" C-m
tmux select-pane -t 0

tmux new-window -t $SESSION:4 -n 'Client'
sleep 2
tmux send-keys "ruby client.rb -r /employers -t json" C-m

# Set default window
tmux select-window -t $SESSION:1

# Attach to session
tmux -2 attach-session -t $SESSION
