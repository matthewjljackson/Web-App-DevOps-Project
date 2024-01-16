# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.

## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.



## Delivery Date

In commit 3f8847458624e86993c9cb8ba97b1801b6c58b02 a delivery date was added to orders

- a delivery date was added to the table to see the value of this order property
- it was also added as a new input to the form
- this value would be returned in the get order route

## Docker

### Process

The containerization process involved initialising a Docker file with the following:

- parent python image
- our application code
- installing dependancies for connecting to the db
- installing dependancies for used by the application
- exposing a port
- command for running the application

### Commands used

- docker build -t devops-image .
- docker run -p 5001:5001 devops-image
- docker login
- docker tag devops-image:latest matthewjljackson/devops-image:latest
- docker push matthewjljackson/devops-image:latest

## terraform

### Networking

#### variables

- resource_group_name
- location
- vnet_address_space

#### resources

- A resource group was created to contain our networking resources
- A VNet was created to be used by the AKS cluster
- We created 2 subnets for use by the control plane and worker nodes
- A NSG was created with 2 rules:
  - 1 to allow inbound traffic to kube-apiserver from my ip-address
  - 1 to allow inbound traffic for SSH

#### outputs

- vnet_id
- control_plane_subnet_id
- worker_node_subnet_id
- resource_group_name
- aks_nsg_id

### Cluster Module

#### variables

- aks_cluster_name
- cluster_location
- dns_prefix
- kubernetes_version
- service_principal_client_id
- service_principal_secret
- vnet_id
- control_plane_subnet_id
- worker_node_subnet_id
- resource_group_name

#### resources

- Here we define the AKS cluster, using the variables, with a default node pool for the cluster. We also define a service principal to handle authentication.

#### outputs

- aks_cluster_name
- aks_cluster_id
- aks_kubeconfig

### Creating the cluster

- In the root of the repo we set up the main.tf which uses a provider for Azure authentication and where we use our networking and cluster module.
- Once correctly configured we can use `terraform apply` to create the resources in Azure.
- terraform.tfvars was used for environment variables used by the provider and the file was added to the .gitignore in order to not leak personal data.

### AKS Deployment

- I created our `application-manifest.yaml` file with 2 key features:
  - A `flask-app-service` for routing internal communication
  - A `flask-app-deployment` for our application code
- I then ran `kubectl apply -f application-manifest.yaml` to execute the k8s code
- I then ran `kubectl port-forward deployment/flask-app-deployment 5001:5001` to test the application locally
