
`log.vim` offers multiple functions that allow you to hide anything that isn't helpful to you during debug.
You can remove file paths and object/component hierarchies that make the message unnecessarily long.
You can decide exactly which lines to see and which to hide based on multiple search terms.
Think of it as in-vim `grep <search-term1> -e <search-term2> ... <log> | grep -v <search-term3> -e <search-term4> ...` but faster and much more dynamic.


## Folding based on search terms
### Gif demo
![Alt Text](https://github.com/wnim/UVM-Log-Focus/blob/main/UVM-log-Focus-Demo.gif)

![Alt Text](https://github.com/wnim/UVM-Log-Focus/blob/main/UVM-log-Focus-Longer-Demo.gif)

| Shortcut     | Action                      |
|-----------|--------------------------------|
| \<Leader>l | Add search term to register l |
| \<Leader>k | Add search term to register k |
| \<Leader>j | Add search term to register j |
| \<Leader>z | Apply folds                   |

_It helps to know the basics of vim folds to use effectively. You will sometimes want to manually open and close the folds_

https://vimdoc.sourceforge.net/htmldoc/fold.html

#### A useful subset:
- `{Visual}zf`	Operator to create a fold.
- `zo` Open one fold under the cursor.
- `zc` Close one fold under the cursor.
- `zR` Open all folds.  This sets 'foldlevel' to highest fold level.
- `zd` Delete one fold at the cursor.

## Removing uninteresting parts of the UVM log prints

| Shortcut     | Action                                 |
|--------------|----------------------------------------|
| \<Leader>rp  | Remove file path (keep file name)      |
| \<Leader>rh  | Remove hierarchy (keep last component) |
| \<Leader>rfh | Remove full hierarchy.                 |

## Installation
1. Download log.vim
2. Place it into ~/.vim/plugin/

* [ ] TODO: I need to figure out how to modernize this and allow it to be installed via vim-plug, vundle etc.
