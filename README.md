# home-router
Example project to manage a home router configuration. 

# Requirements

- GNU make or compatible to run Makefile targets
- python 3.x.x
- python virtualenv package to run ansible inside a virtualenv
- A linux server with ubuntu 18.04 (might work with other versions as well). Prefered to have at least 2 network interfaces one for public and another for private
- Linux server preconfigured. User, key authentication and network needs to be preconfigured.

# Operation

## Environment
```bash
# Install os depepndecies needed 
# It supports debian based linux (tested on ubuntu 18.04) and MacOS
# This is only needed to be run once 
make osdep
# Generate the virtualenv for running ansible
make
# Enable the virtualenv
source .env/bin/activate
```
## Configuration

Basic configuration like user, key authentication, docker and network interfaces needs to be preconfigured and they are not automated yet.  


### Network
This example playbook will asume the home network will use a 192.168.1.0/24 subnet. This can be changed through variables and inventory file shown in the next sections

### Inventory
This example playbook has a custom `ansible.cfg` file in the root folder and that file is pointing to the `hosts/` folder where invetory files are stored. If using the virtualenvironment, it should have everything automatically in place as well as all the dependecied needed.

### Roles configurations

In this example variables for the ansible playbooks and roles are set in the `host_vars/` folder and set on a per host basis (this still has only one host), but in the future functions can be split to multiple hosts.  

Roles:

- fcastello.firewall (from ansible gallaxy) or https://github.com/fcastello/ansible-role-firewall for details how to configure it.
- fcastello.dhcp_docker (from ansible gallaxy) or https://github.com/fcastello/ansible-role-dhcp-docker for details how to configure it.

### Default configs

- **Router ip:** 192.168.1.1 (for ansible)
- **Public Interfaces (Masquerade):** eth0 (it can be set to multiple interfaces, this should be public interfaces)
- **OpenPorts:** 22
- **Whitelisted networks:** 192.168.0.0/16, 172.16.0.0/12 and 10.0.0.0/8
- **DHCP range:** DHCP server assigns ips from 192.168.2.21 to 192.168.2.250


## Playbooks
Most playbooks have been abstracted by a `make` target for making it easy to run. However, feel free to use them as suited. And remember to configure the parameters as this are set as examples.
```bash
# To run the targets, a virtualenv needs to be already created, see earlier sections for confoguring it otherwise the make targets will fail.
# Configure the router completely ALL FUNCTIONS
make router
# Apply firewall
make firewall
# Deploy DHCP server
make dhcp
```

# Limitations
- IPv4 only for now
- While the firewal can set multiple interfaces to masquerade, tachnically this router can have more than 1 internet connection ro mutiple routes. However, seting up routing is not yet in the scope of this project.


# To Do
- Basic configs (users, auth keys, ssh)
- Configure Network Interfaces on router
- Configure Docker on server
- Configure a DNS Server
- Configure a VPN server
- COnfigure multihomed routing or vpns with policy routing

# Disclaimer
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.