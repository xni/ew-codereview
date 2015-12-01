The project contains few script to perform versioned, DRY,
git-workflow agnostic code reviews.

## Motivation
I have to perform a lot of code reviews. About 20 a week.
So I'm very concerned about tools for that. From my point of view,
all codereview systems I work with (GitHub, Stash, Retvield)
are not perfect. Because:
  * I like my text editor config, syntax highlight, navigation hotkeys.
    Because code review is not looking througth, it is about reading carefully,
    performing in-mind tests and gaining deep understanding of the code in the review and out of it.
  * I do not like to re-review chunks of code I already accepted.
    Some kind of improvement is done by Retvield, which stores multiple versions of a patch.
    But this is only a part of a solution: you are to have Retvield installed,
    you have to convince all you colleagues to change a familiar git workflow to Retrields versioned patches.
  * Sometimes it is not easy to focus on the main idea of the review.
    Yes, you may ask an author to split the review into several chunks,
    but sometimes it is not appropriate.
  * Sometimes you are too tired and want to continue a review process later.
    So you have to save you current reviewing state and go home.
    I don't know the way to do it in current web codereview systems.
  * Some people likes to perform separate fixing commits in the same pull request:
    "Just CC" or "Fixing memory leak", another — like to `git commit --amend` their changes,
    so the pull-request always contains the only commit. We don't have any restrictions on this,
    but none of the web-codereview systems deals this cases in a uniform way.
    But for me, as a reviews, it really does not matter how the change was made.
    I'm interested only in code changes.

## Solution
That's why I started this repository. Because I know a workaround to bypass
all the problems above in a very-very simple way. And I'm going to share this knowledge.

This is how it works

```
$ git checkout master
$ cat README 
This is a common content
$ git checkout feature-branch
$ cat README 
README
======

This is a common content

Best wishes,
Konstantin Nikitin
$ git review prepare feature-branch master                         
Path to cache dir for current repository is not specified.
Please, set it up at first:
    git config --local --path --add reviews.cache-dir YOUR_PATH
$ git config --local --path --add reviews.cache-dir /tmp/reviews
$ git review prepare feature-branch master
$ git review cf
Files orig/README and latest/README differ
$ git review sr README
  ---------------------------------|  README                           
  ---------------------------------|  ======                           
  ---------------------------------|                                   
  This is a common content         |  This is a common content
  ---------------------------------|                                   
  ---------------------------------|  Best wishes,                     
  ---------------------------------|  Konstantin Nikitin               
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
orig/README                         latest/README                                                                                           
Then, using :diffget, :diffput, or other diff-merge tool move reviewed chunks from latest to orig and save orig.

$ git review cf      
Files orig/README and latest/README differ
$ git review sr README
  README                           |  README
  ======                           |  ======
                                   |  
  This is a common content         |  This is a common content
  ---------------------------------|                                   
  ---------------------------------|  Best wishes,                     
  ---------------------------------|  Konstantin Nikitin               
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
  ~                                |  ~                                
orig/README                         latest/README     
```
