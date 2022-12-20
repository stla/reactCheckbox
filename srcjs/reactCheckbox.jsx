import { reactShinyInput } from "reactR";
import "react-input-checkbox/lib/react-input-checkbox.min.css";
import "./bootstrap-theme.css";
import "./fancy-theme.css";
import "./material-theme.css";
import { Checkbox } from "react-input-checkbox";
import parse from "html-react-parser";

const unescapeHtml = (html) => {
  let el = document.createElement("div");
  return html.replace(/\&[#0-9a-z]+;/gi, function(enc) {
    el.innerHTML = enc;
    return el.innerText;
  });
};

const isnonnullobject = (x) => {
  return x !== null && typeof x === "object";
};

const isHTML = (x) => {
  return isnonnullobject(x) && x.hasOwnProperty("__html");
};

const parselabel = (label) => {
  if(isHTML(label)) {
    return parse(unescapeHtml(decodeURI(label.__html)));
  } 
  return label;
};

const makeStyle = (theme, styles) => {
  if(styles === null) {
    return false;
  }
  let style = "";
  for(let classname in styles) {
    const sibling = `.${theme}__image.${classname}`;
    const css = styles[classname];
    for(let what in css) {
      style = style + `.${theme}__input${what} + ${sibling} {${css[what]}}`;
    }
  }
  return {__html: style};   
};

const App = (props) => {

  const [values, setValues] = React.useState(props.value);

  const allTrue = () => {
    for(const x of values) {
      if(!x) {
        return false;
      }
    }
    return true;
  };
  
  const allFalse = () => {
    for(const x of values) {
      if(x) {
        return false;
      }
    }
    return true;
  };
  
  let status;
  if(allTrue()) {
    status = 2;
  } else if(allFalse()) {
    status = 0;
  } else {
    status = 1;
  }
  const [all, setAll] = React.useState(status); // 0 for none, 1 for some, 2 for all

  const ncheckboxes = props.value.length;

  const trueValues = Array(ncheckboxes);
  const falseValues = Array(ncheckboxes);
  for(let i = 0; i < ncheckboxes; i++) {
    trueValues[i] = true;
    falseValues[i] = false;
  }

  const labels = props.labels;
  const classes = props.classes;

  React.useEffect(() => {
    if(allTrue()) {
      setAll(2);
    } else if(allFalse()) {
      setAll(0);
    } else {
      setAll(1);
    }
  }, [values]);

  const toggleAll = () => {
    let newvalues;
    if(allTrue()) {
      newvalues = falseValues;
      setAll(0);
    } else {
      newvalues = trueValues;
      setAll(2);
    }
    setValues(newvalues);
    props.setShinyValue(newvalues);
  };

  const toggleAt = (i) => {
    values[i] = !values[i];
    setValues([...values]);
  };

  const onChange = (i) => {
    toggleAt(i);
    props.setShinyValue(values);
  };

  const theme = props.theme;
  const styles = makeStyle(props.theme, props.styles);

  return (
    <div>

      <Checkbox
        theme={theme}
        value={all === 2}
        indeterminate={all === 1}
        onChange={toggleAll}
        modification={props.headClass}
      >
        {props.headLabel}
      </Checkbox>

      <ul style={{ listStyleType: "none" }}>
        {values.map((v, i) => {
          return (
            <li>
              <Checkbox
                theme={theme}
                value={v}
                modification={classes[i]}
                onChange={() => onChange(i)}
              >
                {labels[i]}
              </Checkbox>
            </li>
          );
        })}
      </ul>

      {styles ?
        <style 
          dangerouslySetInnerHTML={styles} 
        />
        : null 
      }

    </div>
  );
};

const ReactCheckBoxInput = ({ configuration, value, setValue }) => {
  return (
    <App 
      value={value}
      theme={configuration.theme + "-checkbox"} 
      labels={configuration.labels.map(parselabel)}
      classes={configuration.classes}
      headLabel={configuration.headLabel}
      headClass={configuration.headClass}
      styles={configuration.styles}
      setShinyValue={setValue} 
    />
  );
};

reactShinyInput(
  ".reactCheckbox",
  "reactCheckbox.reactCheckbox",
  ReactCheckBoxInput
);
