
"The idea of this plugin is to search for terms (aka put them in the @/ register) and then
"press <leader>(j or l or k) which would add that search term into the register.
"j, l, k each have a different meaning behind them.
"Then lines in the log file are added to folds to allow us to only see what's important
"<leader>c(j or l or k) is to clear the register.
"<leader>z is to make the folds actually happen.
"
"supposedly unralted but helpful
"vim fold cheatsheet
"zr to unfold
"zf
"zo
"zc
"
fu! CalcVisibleLines()
let result=0
let i=0

while (i <= line('$'))
if foldclosed(i) > 0
    let i = foldclosedend(i)+1
    continue
    endif
    let i+=1
    let result += 1
endw
let @n = result-1
endfu

function ChangeWindowContentWithSearchTerms()
  "This doesn't work well if the user opened more horizontal splits because the  'execute' commands assume a certain configuration of windows
  "Will have to see if I can give my status window some special name or number and make a command that know to switch to it and back
  if bufname("%") == "SearchTerms"  
    "delete all lines in buffer
    1,$d 
    "Put the text into variables
    let K = execute("echo '@k: Hiding matches to     : '@k") 
    let L = execute("echo '@l: Hiding non-matches to : '@l") 
    let J = execute("echo '@j: Showing non-matches to: '@j")
    let N = execute("echo '@n: Num of displayed lines: '@n")
    "Print variable content onto buffer
    put! = L
    put! = K
    put! = J
    put! = N
    "Removes any empty lines that may have been left after the previous operations
    " 'g' commands are showing some weird output when I just open the log, I should use :h silent on both of them
    silent! g/^$/d 
    "Move (m) all lines starting with ^ (which matches every line) to position 0
    silent! g/^/m0 
    "Make the windows size 2 times the number of lines.
    "TODO need to find a way to resize to num of lines including wraps
    "Right now just doubling so the size is always 3*2=6 lines
    execute('resize ' . 2*line('$')) 
  endif
endfunction

function RefreshFoldexprWin()
  windo call ChangeWindowContentWithSearchTerms()
endfunction

function SetFoldexprWin()
  new SearchTerms
 " SearchTerms 
  "file SearchTerms 
  set filetype=SearchTerms 
  "TODO decide if nowrap is better or not
  "set nowrap
  set wrap
  let @l=""
  let @k=""
  let @j=""
  let @n=""
  "TODO figure out how to return the focus to the main window
  " https://www.reddit.com/r/vim/comments/17lf0ln/unwanted_behavior_in_my_first_vim_plugin/
  " No one helped :(
  "commands below are two difference options that I tried and failed
  " Maybe I can learn from NERDtree how to do it.
  "wincmd w
  "execute("normal \<C-w>j")
  call RefreshFoldexprWin() 
endfunction



function DecideWhatToFold(line)
"L - show matches, hide none matches
"K - hide matches - Stronger than L
"J - Show non matches - Stronger than L and K
  if !empty(@j) && (a:line !~ @j)
    return 0
  elseif empty(@k)
    return a:line !~ @l
  else 
    return (a:line !~ @l) || (a:line =~ @k)
  endif
endfunction

augroup LOG
  au!
  autocmd BufNewFile,BufRead *sim.log setf log | call SetFoldexprWin()  
  autocmd BufNewFile,BufRead SearchTerms setf SearchTerms   
  "auto exit without save if the only window left is our SearchTerms
  autocmd WinEnter * if winnr('$') == 1 && bufname("%") == "SearchTerms" | q! | endif
  "I don't want my folds to open while debugging due to a search
  "If I want to search the whole log, I will zr to unfold it and then search
  set foldopen-=search
  
  "nnoremap <Leader>z :setlocal foldexpr=DecideWhatToFold(getline(v:lnum)) foldmethod=expr foldlevel=0 foldcolumn=2 foldminlines=0 \| call RefreshFoldexprWin()<CR>
  nnoremap <Leader>z :setlocal foldexpr=DecideWhatToFold(getline(v:lnum)) foldmethod=expr foldlevel=0 foldcolumn=2 foldminlines=0 \| call CalcVisibleLines() \| call RefreshFoldexprWin()<CR><CR>



  "map <Leader>cX to clear register X and refresh the search keys window
  "map <Leader>X to add the string in @/ to X (with 'or' operator)
  for i in ['j', 'k', 'l']
    execute 'nnoremap <Leader>c' . i . ' q' . i . 'q \| :call RefreshFoldexprWin()<CR>'
    execute "nnoremap <Leader>" . i . " :let @" . i . " = (empty(@" . i . "))? @/ : @" . i . " . '\\\\|' . @/ \\| call RefreshFoldexprWin()<CR>"
  endfor
  
  "I'm leaving these comments in, because while they use code duplication, they are more readable than the expression above
  "which might actually be useful one day if I want to edit the above term.
  "nnoremap <Leader>l :let @l = (empty(@l))? @/ : @l . '\\|' . @/ \| call RefreshFoldexprWin()<CR>
  "nnoremap <Leader>k :let @k = (empty(@k))? @/ : @k . '\\|' . @/ \| call RefreshFoldexprWin()<CR>
  "nnoremap <Leader>j :let @j = (empty(@j))? @/ : @l . '\\|' . @/ \| call RefreshFoldexprWin()<CR>
  
  "nnoremap <Leader>cl qlq \| :call RefreshFoldexprWin()<CR>
  "nnoremap <Leader>ck qkq \| :call RefreshFoldexprWin()<CR>
  "nnoremap <Leader>cj qjq \| :call RefreshFoldexprWin()<CR>
 
  "save ex command output history in register h
  redir @h
  
  "Sort my mini-logs by timestamp 
  noremap <Leader>s :sort f /) @/<CR>
  
  "get rid of directory hirarchy in the log file and just keep the filename
  command RmPrePath %s/\/[\.a-zA-Z_\/0-9\-]\+\/
  noremap <Leader>rp :RmPrePath<CR>

  "Get rid of the hierarchy part of the uvm log
  command RmFullHier %s/ uvm_test_top[_@.a-z0-9]\+/
  command RmHier %s/\.[a-z_.1-9]\+\./\.\./
  noremap <Leader>rh :RmHier<CR>
  noremap <Leader>rfh :RmFullHier<CR>

  "TODO Add "RmID" command
augroup END








