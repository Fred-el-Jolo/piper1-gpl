#!/usr/bin/env fish

set --local voices_dir /home/jolo/dev/piper1-gpl/data
echo voices_dir=$voices_dir

#if argparse 'm/message' 'd/debug' 'v/voice=!not test -f "$voices_dir/{$_flag_value}.onnx"' -- $argv
if argparse 'm/message=' 'd/debug' 'v/voice=' -- $argv

    if set -q _flag_debug
        echo "message=$_flag_message"
        echo "debug=$_flag_debug"
        echo "voice=$_flag_voice"
    end

    set --local voice_file
    set --local voice_param ""
    if set -q _flag_voice
        set --local voice_file "$voices_dir/$_flag_voice.onnx" 

        if not test -f $voice_file
            echo not a file: $voice_file
            return -1
        end

        set voice_param ", \"voice\": \"$_flag_voice\""
        
        if set -q _flag_debug
            echo "voice_param=$voice_param"
        end
    end

    if not test -d ~/.local/state/audio-notif
        mkdir -p ~/.local/state/audio-notif
    end

    curl -X POST -H 'Content-Type: application/json' -d "{ \"text\": \"$_flag_message\" $voice_param }" -o ~/.local/state/audio-notif/audio.wav 127.0.0.1:5000 && ffplay ~/.local/state/audio-notif/audio.wav -autoexit -nodisp
end

