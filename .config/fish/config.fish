function fish_prompt -d "Write out the prompt"

    if [ $status -eq 0 ]
        set emoticon "^_^"
        set color green
    else
        set emoticon ">_<"
        set color red
    end

    printf "%s%s %s%s:%s %s" (set_color -o $color) $emoticon (set_color normal)
end