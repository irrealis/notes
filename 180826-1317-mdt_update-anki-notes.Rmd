---
title: "180826-1317-mdt_update-anki-notes.Rmd"
---

```{python }
%pushd /mnt/Work/Repos/irrealis/flashcards
```

```{python }
import yaml
```

Stream to python object to stream:
```{python }
import yaml
x = yaml.load(open("markdown_mathjax_demo.yml"))
print(x)
print(yaml.dump(x))
```

Stream to representation graph to stream
```{python }
import yaml
nodes = yaml.compose(open("markdown_mathjax_demo.yml"))
print(nodes)
print(yaml.serialize(nodes))
for node in nodes:
  print(yaml.serialize(node))
```

Stream to events to stream:
```{python }
import yaml
events = yaml.parse(open("markdown_mathjax_demo.yml"))
print(events)
print(yaml.emit(events))
```

```{python }
x = yaml.compose(open("markdown_mathjax_demo.yml"))
d = {x.value:v.value for x, v in x.value}
print(yaml.load(yaml.serialize(d['notes'][0])))

[(k,v) for k,v in x.value if k.value == 'notes']

print(yaml.serialize(yaml.MappingNode(tag='tag:yaml.org,2002:map', value = [(k,v) for k,v in x.value if k.value == 'notes'])))


```
