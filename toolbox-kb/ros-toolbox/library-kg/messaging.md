---
type: Simulink Block Category
title: Messaging
description: Topic publish/subscribe and message creation
tags: [publish, subscribe, blank, message, topic, header]
status: stable
source: mathworks_toolbox
library_root: ROS Toolbox
category_path: Messaging
block_count: 8
---

# Messaging

Use these blocks for messaging.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Blank Message | robotlib/Blank Message | R2023a+ | Create an empty ROS message structure — use for initializing message fields before populating and publishing |
| Header Assignment | robotlib/Header Assignment | R2023a+ | Assign timestamp and frame ID to a message header — use for stamping messages with timing and coordinate frame info |
| Publish | robotlib/Publish | R2023a+ | Publish a ROS message to a topic — use for sending data from Simulink to other ROS nodes |
| Subscribe | robotlib/Subscribe | R2023a+ | Subscribe to a ROS topic and receive messages — use for bringing external ROS data into your Simulink model |
| Blank Message | ros2lib/Blank Message | R2023a+ | Create an empty ROS message structure — use for initializing message fields before populating and publishing |
| Header Assignment | ros2lib/Header Assignment | R2023a+ | Assign timestamp and frame ID to a message header — use for stamping messages with timing and coordinate frame info |
| Publish | ros2lib/Publish | R2023a+ | Publish a ROS message to a topic — use for sending data from Simulink to other ROS nodes |
| Subscribe | ros2lib/Subscribe | R2023a+ | Subscribe to a ROS topic and receive messages — use for bringing external ROS data into your Simulink model |
