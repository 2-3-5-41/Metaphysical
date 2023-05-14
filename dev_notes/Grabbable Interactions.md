
## Grabbable object

The grabbable object node/class will contain the logic that tells the object who is grabbing it, and what point to 'virtualy parent' to _through offset math, and global positioning.

## Grabber

The grabber is a node/class that contains all logic to interact with a grabbable object, external nodes/classes _(like the InteractionLaser, and the palm)_ will communicate with the grabber, adding a grabbable object(s) to it's list of grabbable objects, then telling it whether it should be grabbing or not.

If the grabber is told to start grabbing, it will communicate to the first, closest, or all grabbable object(s) in the list of grabbable objects that they are being grabbed by this grabber. Then those grabbable objects will use their own logic to follow an offset point to the grabber while the grabber is actively grabbing. When the grabber is told to stop grabbing, it will tell the grabbed object(s) that they are no longer being grabbed.