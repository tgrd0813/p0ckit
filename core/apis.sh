#This file is just to make naas work but going to add more local apis later
naas() {
    local cmd="$1"
    if [[ ! -d "${script_hm}/.no-as-a-service" ]]; then
        read -e -p "NaaS (no-as-a-service) is not installed, do you want to install it (Y/n)? " ans
        ans=${ans:-y}
        ans=${ans,,}
        if [[ "$ans" != "y" ]]; then
            echo Ok not installing naas
        else
            git clone https://github.com/hotheadhacker/no-as-a-service.git .no-as-a-service
        fi
    else
        if [[ "$cmd" == "start" ]]; then
            $(
                cd .no-as-a-service 
                npm start
            ) & 
            api_pid=$!
        fi
    fi

    if [[ "$cmd" == "stop" ]]; then
        kill $api_pid
    fi   
}