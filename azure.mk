########################################################################
#
# Manage Azure Resources
#
########################################################################

define AZURE_HELP
Support for managing azure from the command line:

  aztoken       Check if a login token is active;
  azlogin	Generate a login token;
  azsubs	Set the subscription to $(AZ_SUBSCRIPTION);
  azlistsubs    List the subscriptions associated with the login;

  vmlist	List of virtual machine under the subscription;
  vmstatus	Status of $(VIRTUAL_MACHINES);
  vmstart	Start all $(VIRTUAL_MACHINES);
  vmstop	Stop all $(VIRTUAL_MACHINES);

  %.start	Start a virtual machine;
  %.stop	Stop a virtual machine;
  %.delete	Delete a virtual machine.

endef
export AZURE_HELP

help::
	@echo "$$AZURE_HELP"

# Expect AZ_SUBSCRIPTION and VIRTUAL_MACHINES defined locally.

ifneq ("$(wildcard azure_local.mk)","")
  include azure_local.mk
endif

########################################################################

azlogin:
	az login

vmlist:
	az vm list --output=tsv | awk 'BEGIN {FS="\t"} {print($$10)}'

vmstatus:
	az vm list --show-details --output table

vmstart: $(VIRTUAL_MACHINES:=.start)

%.start:
	az vm start --no-wait --name $* --resource-group $*

vmstop: $(VIRTUAL_MACHINES:=.stop)

%.stop:
	az vm deallocate --no-wait --name $* --resource-group $*

%.create:
	az XXXX group create -n $* -l WestUS2
	az vm create XXXX

########################################################################
# The following is essentially a cheatsheet of the various commands I use.

# Check we have a token and if not then az login to get one.

aztoken:
	az account get-access-token

azlistsubs:
	az account list

azsubs:
	az account set --subscription $(AZ_SUBSCRIPTION)

%.delete:
	az vm delete  --name $* --resource-group $*
