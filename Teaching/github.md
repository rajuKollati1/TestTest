r Daemon"]
        Images["🗃️ Images"]
        Containers["📦 Containers"]
        Volumes["💾 Volumes"]
        Network["🌐 Network"]
    end

    Registry["☁️ Docker Registry<br>(e.g., Docker Hub)"]

    %% --- Connections ---
    Client -- "Build, Run, Pull, Push" --> Daemon
    Daemon -- "Pulls/Pushes Images" --> Registry
    Daemon -- "Manages" --> Images
    Daemon -- "Manages" --> Containers
    Daemon -- "Manages" --> Volumes
    Daemon -- "Manages" --> Network

    %% --- Apply Styles ---
    class Client clientStyle
    class Daemon,Images,Containers,Volumes,Network hostStyle
    class Registry registryStyle
