# 🐳 Simple Docker Architecture

<div style="transform: scale(1.5); transform-origin: top left;">

```mermaid
flowchart TB
    %% --- Style Definitions ---
    classDef clientStyle fill:#cde4ff,stroke:#99bde5,stroke-width:2px,color:#333
    classDef hostStyle fill:#d4edda,stroke:#a3d0a8,stroke-width:2px,color:#333
    classDef registryStyle fill:#fef2c0,stroke:#e9d37f,stroke-width:2px,color:#333

    %% --- Components ---
    Client[💻 Docker Client (CLI)]
    subgraph DockerHost[Docker Host]
        Daemon[⚙️ Docker Daemon]
        Images[📚 Images]
        Containers[📦 Containers]
    end

    Registry[☁️ Docker Registry (e.g., Docker Hub)]

    %% --- Connections ---
    Client -- docker build/run/pull --> Daemon
    Daemon -- pulls --> Registry
    Daemon -- creates/runs --> Containers
    Images -- are used to create --> Containers

    %% --- Apply Styles ---
    class Client clientStyle
    class Daemon,Images,Containers hostStyle
    class Registry registryStyle
```