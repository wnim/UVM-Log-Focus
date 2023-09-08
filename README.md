# UVM-Log-Focus
> UVM-Log-Focus comes with a variety of functions that will help you ignore the inherent noise of UVM log files.
> 
_Despite the many TODOs you see in this README (and in code), the plugin is functional._
## Folding based on search terms
### Gif demo
![Alt Text](https://github.com/wnim/UVM-Log-Focus/blob/main/UVM-log-Focus-Demo.gif)

![Alt Text](https://github.com/wnim/UVM-Log-Focus/blob/main/UVM-log-Focus-Longer-Demo.gif)

| \<Leader>l | Add search term to register l |
|-----------|-------------------------------|
| \<Leader>k | Add search term to register k |
| \<Leader>j | Add search term to register j |
| \<Leader>z | Apply folds                   |

## Removing uninteresting parts of the UVM log prints

| \<Leader>rp  | Remove file path (keep file name)      |
|--------------|----------------------------------------|
| \<Leader>rh  | Remove hierarchy (keep last component) |
| \<Leader>rfh | Remove full hierarchy.                 |

## Installation
1. Download log.vim
2. Place it into ~/.vim/plugin/

* [ ] TODO: I need to figure out how to modernize this and allow it to be installed via vim-plug, vundle etc.
