{
    hosts = {
        laptop = "./laptop.nix";
        pc = "./pc.nix";
    };
    
    # choose what system to use
    imports = [
        hosts.laptop
    ];
}
