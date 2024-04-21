# diagram.py
# https://diagrams.mingrammer.com/docs/nodes/aws#awssecurity
from diagrams import Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB
from diagrams.aws.network import APIGateway
with Diagram("Web Service", show=False):
    ELB("lb") >> EC2("web") >> [RDS("userdb"), RDS("userdb2")] >> APIGateway("dds")
# python3 diagram.py