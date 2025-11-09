## im writting a kuberentes commands & what happen in project  structure 
``
suppose we have created a kuberntes container those steps we have 
    firt we have cluster that k8s cluter that is the main of the kubernets then we have a name space we choose a name 
     
     before the create the k8s first we check the k8s version 
     we dont have k8s at that time install k8s tool and then run the config command 
     we are using the command
     ```console
## kubectl 
kube==kuberntes,ctl==command line tool
## chacoo install kubernets-cli  
            this command usess to install kueberntes cli all commands 
   after that we check the how many pods we have using the this commands
   ## kubectl get pods 
     this command show the how many pods runing the cluster in the node and this is the smallest deployment unit in the cluster k8s
   ## kubectl get pods -A 
   this command show the  how many pods runing the cluster in the node including all  the name spaces we have 
   ## kubectl describe pod (podname )
   this cmd use a trabuleshutting cmd to datail informatoin about the pod link how many changes in the pod and which location in the pod how much gain the resorces like cpu memory storsge
   ## kubectl get namespace 
   shows the all name spaces in the cluster name space is the supparate name work space or folder inside the cluster 
   ## kubectl delete pod (pod nsme)
   to delete that pod
   ## kubectl get deployment
   list all the deployments in the current name space 

   deployment is the imp topic bcz its how yo create , update , scale ,manage pods and automatically  
   ## kubectl create deploy (name) --image=(image name)
   name = your img name
   image name == our server name
