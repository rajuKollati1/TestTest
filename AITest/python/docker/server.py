import os
from typing import Optional

from kubernetes import client, config
from mcp.server.fastmcp import FastMCP


# ---------------------------------------------------------
# Kubernetes configuration
# ---------------------------------------------------------

try:
    # Running inside Kubernetes
    config.load_incluster_config()
    print("Loaded in-cluster Kubernetes configuration")
except Exception:
    # Useful when testing locally
    config.load_kube_config()
    print("Loaded local kubeconfig")


core_api = client.CoreV1Api()
apps_api = client.AppsV1Api()


# ---------------------------------------------------------
# MCP Server
# ---------------------------------------------------------

mcp = FastMCP(
    "Kubernetes AI Agent",
    host="0.0.0.0",
    port=8000
)


# ---------------------------------------------------------
# Tool 1 - Get Pods
# ---------------------------------------------------------

@mcp.tool()
def get_pods(namespace: str = "default") -> str:
    """
    Get pods from a Kubernetes namespace.
    Read-only operation.
    """

    try:
        pods = core_api.list_namespaced_pod(namespace)

        if not pods.items:
            return f"No pods found in namespace '{namespace}'."

        result = []

        for pod in pods.items:
            result.append(
                f"Pod: {pod.metadata.name} | "
                f"Status: {pod.status.phase} | "
                f"Node: {pod.spec.node_name}"
            )

        return "\n".join(result)

    except Exception as e:
        return f"Error getting pods: {e}"


# ---------------------------------------------------------
# Tool 2 - Pod Count
# ---------------------------------------------------------

@mcp.tool()
def get_pod_count(namespace: str = "default") -> str:
    """
    Return number of pods in a Kubernetes namespace.
    """

    try:
        pods = core_api.list_namespaced_pod(namespace)

        return (
            f"Namespace '{namespace}' has "
            f"{len(pods.items)} pod(s)."
        )

    except Exception as e:
        return f"Error getting pod count: {e}"


# ---------------------------------------------------------
# Tool 3 - Get Nodes
# ---------------------------------------------------------

@mcp.tool()
def get_nodes() -> str:
    """
    Get Kubernetes nodes.
    Read-only operation.
    """

    try:
        nodes = core_api.list_node()

        if not nodes.items:
            return "No Kubernetes nodes found."

        result = []

        for node in nodes.items:

            ready = "Unknown"

            for condition in node.status.conditions or []:
                if condition.type == "Ready":
                    ready = condition.status

            result.append(
                f"Node: {node.metadata.name} | "
                f"Ready: {ready}"
            )

        return "\n".join(result)

    except Exception as e:
        return f"Error getting nodes: {e}"


# ---------------------------------------------------------
# Tool 4 - Get Deployments
# ---------------------------------------------------------

@mcp.tool()
def get_deployments(namespace: str = "default") -> str:
    """
    Get deployments from a namespace.
    """

    try:
        deployments = apps_api.list_namespaced_deployment(namespace)

        if not deployments.items:
            return f"No deployments found in '{namespace}'."

        result = []

        for deployment in deployments.items:

            desired = deployment.spec.replicas or 0
            available = deployment.status.available_replicas or 0

            result.append(
                f"Deployment: {deployment.metadata.name} | "
                f"Desired: {desired} | "
                f"Available: {available}"
            )

        return "\n".join(result)

    except Exception as e:
        return f"Error getting deployments: {e}"


# ---------------------------------------------------------
# Tool 5 - Get Pod Details
# ---------------------------------------------------------

@mcp.tool()
def get_pod(
    pod_name: str,
    namespace: str = "default"
) -> str:
    """
    Get details about a specific pod.
    """

    try:
        pod = core_api.read_namespaced_pod(
            name=pod_name,
            namespace=namespace
        )

        return (
            f"Name: {pod.metadata.name}\n"
            f"Namespace: {pod.metadata.namespace}\n"
            f"Status: {pod.status.phase}\n"
            f"Node: {pod.spec.node_name}\n"
            f"Pod IP: {pod.status.pod_ip}\n"
        )

    except Exception as e:
        return f"Error getting pod '{pod_name}': {e}"


# ---------------------------------------------------------
# Main
# ---------------------------------------------------------

if __name__ == "__main__":

    print("Starting Kubernetes AI Agent...")
    print("Listening on 0.0.0.0:8000")

    mcp.run(
        transport="streamable-http"
    )