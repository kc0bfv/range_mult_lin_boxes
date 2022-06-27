You will require the AWS command line tools, and must configure them with `aws configure`.  You will also need to download terraform (it's just a single binary file, so it's easy).

You'll need to copy "secrets.tf_TEMPLATE" into "secrets.tf", then fill it out a little.  Make up some passwords, create a domain at `freedns.afraid.org` for the Guac server, set it to use v2 dynamic updates, and put the URLs for updating IPv4 and v6 into the secrets file.

Then run:

```
ssh-keygen -f admin_key
ssh-keygen -f kali_key
terraform init
terraform apply
```

That'll create the hosts file you need for Ansible...
