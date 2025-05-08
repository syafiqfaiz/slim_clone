## Introduction
We regularly generate HTML tables from our backend to replace parts of our front ends (HTML over-the-wire). 
Vanilla HTML is hard to scan and tedious to write, so we'd like to simplify it with the following templating approach:

## The challenge
- Design and code a module that can parse the following template structure and convert it into a HTML string. 
- You should analyse and define the problem space & possible solution approaches before writing code (this can be a plain text file in the project). Do record assumptions made, and feel free to reach out for clarification.
- You should not call third party libraries directly, but you may reference approaches from external sources. You should be able to reason well about all approaches used. 
- You may use any language of your choice (ideally Ruby), and solve it using multiple approaches if you want. 
- To submit your solution, create a new personal project on Github and invite fy.looi@gmail.com. Add your changes as a new Pull Request. 

Input:
``` 
table
  thead
    tr
      td Heading 1
      td Heading 2
  tbody
    tr 
      td Body 1
      td Body 2
```

Output: 
```
<table>
  <thead>
    <tr>
      <td>
        Header 1
      </td>
      <td>
        Header 2
      </td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        Body 1
      </td>
      <td>
        Body 2
      </td>
    </tr>
  </tbody>
</table>
```

## What we value:
- Choose the right problems to solve, then solve them right - sync on problem / approach scope and value, avoid overengineering
- Code that is extremely easy to understand (self documenting) - every function / module should be well named, simple and readable 
- Code that is robust - low surface area for breakage, well encapsulated to minimize change, easy to test
- Solutions that increase our velocity - modules are designed for composition, reuse and extension