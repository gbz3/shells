#!/bin/bash

# カーソルを非表示
tput civis

# 終了時にカーソルを再表示
trap 'tput cnorm' EXIT

# 選択肢の配列
options=("Option 1" "Option 2" "Option 3" "Option 4")
selected=0

# メニュー表示関数
show_menu() {
    # 画面をクリアして先頭に移動
    printf "\033[2J\033[H"
    
    printf "↑↓キーで選択、Enterで確定\n"
    printf "------------------------\n"
    for i in "${!options[@]}"; do
        if [ $i -eq $selected ]; then
            printf "\033[7m>%s\033[0m\n" "${options[$i]}"
        else
            printf " %s\n" "${options[$i]}"
        fi
    done
}

# キー入力ループ
while true; do
    show_menu
    
    read -rsn1 input
    case $input in
        $'\x1b')
            read -rsn2 input
            case $input in
                '[A') # 上矢印
                    ((selected--))
                    if ((selected < 0)); then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B') # 下矢印
                    ((selected++))
                    if ((selected >= ${#options[@]})); then
                        selected=0
                    fi
                    ;;
            esac
            ;;
        '') # エンターキー
            printf "\033[2J\033[H"
            printf "選択された項目: %s\n" "${options[$selected]}"
            exit 0
            ;;
    esac
done

