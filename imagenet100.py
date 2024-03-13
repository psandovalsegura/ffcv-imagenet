import os
from typing import Dict, List, Tuple
from torchvision.datasets import ImageFolder

class ImageNet100Folder(ImageFolder):
    def find_classes(self, directory: str) -> Tuple[List[str], Dict[str, int]]:
        """Finds the class folders in a dataset.
           For ImageNet100, this means the first 100 classes.
        """
        classes = sorted(entry.name for entry in os.scandir(directory) if entry.is_dir())
        if not classes:
            raise FileNotFoundError(f"Couldn't find any class folder in {directory}.")
        
        # only keep the first 100 classes
        classes = classes[:100]
        class_to_idx = {cls_name: i for i, cls_name in enumerate(classes)}
        return classes, class_to_idx
