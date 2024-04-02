# Terraform InfluxDB and Telegraf Deployment

This Terraform project automates the deployment of an InfluxDB instance along with Telegraf on a Google Cloud Platform (GCP) VM instance. InfluxDB is a time-series database used for storing and querying time-series data, while Telegraf is an agent for collecting, processing, aggregating, and writing metrics.

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/) installed on your local machine.
- A Google Cloud Platform (GCP) account.
- Google Cloud SDK installed and configured on your local machine.

## Project Structure

├── influx.tf # Terraform configuration for creating GCP VM instance with InfluxDB and Telegraf
├── influxVPC.tf # Terraform configuration for creating VPC and subnet
├── influx-startup.sh.tftpl # Template file for startup script used by the VM instance
└── README.md # This README file

## Setbacks and improvements:

A separate static extenralip is required, as in order for the ip address to be passed o telegraf configuration, the resource (VM) have to be created first, hence it's not possible to assign the externalIP for the startup script. 

As an alternative, the remote-exec provisioner could be used to modify the value, but it get's quite complex while using ACG environments and limitations based on the time-span of the project and GCP IAM not available. 

## Customize

- Modify `influx.tf` and `influxVPC.tf` to customize instance type, disk size, network configurations, etc., as per your requirements.
- Update `influx-startup.sh.tftpl` to change any installation or configuration parameters for InfluxDB and Telegraf.