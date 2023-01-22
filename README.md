# AWS VPN Server

I created this project for learning purpose. I modified the VPN server installation script from [openvpn-install](https://github.com/Nyr/openvpn-install). 

Before begining to use this, first setup AWS Account and credentials file for packer and terraform to work.

By default the region is `us-east-1`, modify it according to your needs. Every region needs to have image in that region.  

## Running for different region
For Packer - other region

``` bash 
packer build 
    -var 'region=ap-south-1' \
    -var 'base_ami=ami-0be0a52ed3f231c12' \
    main.pkr.hcl
```


For Terraform - other region

``` bash 
terraform apply -auto-approve \ 
    -var "base_ami=ami-01635005445b2ef73" \
    -var "region=ap-south-1" \
    -var "vpc_id=vpc-0bd7991790afc8305"
```

## Output

At the end of the setup, you will have 2 files
- .pem file for the EC2 instance access
- .ovpn file for the VPN Connection

Use the .ovpn file and OpenVPN Client to setup the connection.
