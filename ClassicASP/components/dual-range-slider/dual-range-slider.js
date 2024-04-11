function controlFromInput(fromSlider, fromInput, toInput, controlSlider) {
  const [from, to] = getParsed(fromInput, toInput);
  fillSlider(fromInput, toInput, '#C6C6C6', '#25daa5', controlSlider);
  if (from > to) {
      fromSlider.value = to;
      fromInput.value = to;
  } else {
      fromSlider.value = from;
  }
}
    
function controlToInput(toSlider, fromInput, toInput, controlSlider) {
  const [from, to] = getParsed(fromInput, toInput);
  fillSlider(fromInput, toInput, '#C6C6C6', '#25daa5', controlSlider);
  setToggleAccessible(toInput);
  if (from <= to) {
      toSlider.value = to;
      toInput.value = to;
  } else {
      toInput.value = from;
  }
}

function controlFromSlider(fromSlider, toSlider, fromInput) {
  const [from, to] = getParsed(fromSlider, toSlider);
  fillSlider(fromSlider, toSlider, '#C6C6C6', '#25daa5', toSlider);
  if (from > to) {
    fromSlider.value = to;
    fromInput.value = to;
  } else {
    fromInput.value = from;
  }
}

function controlToSlider(fromSlider, toSlider, toInput) {
  const [from, to] = getParsed(fromSlider, toSlider);
  fillSlider(fromSlider, toSlider, '#C6C6C6', '#25daa5', toSlider);
  setToggleAccessible(toSlider);
  if (from <= to) {
    toSlider.value = to;
    toInput.value = to;
  } else {
    toInput.value = from;
    toSlider.value = from;
  }
}

function getParsed(currentFrom, currentTo) {
  const from = parseInt(currentFrom.value, 10);
  const to = parseInt(currentTo.value, 10);
  return [from, to];
}

function fillSlider(from, to, sliderColor, rangeColor, controlSlider) {
  const rangeDistance = to.max-to.min;
  const fromPosition = from.value - to.min;
  const toPosition = to.value - to.min;
  controlSlider.style.background = `linear-gradient(
    to right,
    ${sliderColor} 0%,
    ${sliderColor} ${(fromPosition)/(rangeDistance)*100}%,
    ${rangeColor} ${((fromPosition)/(rangeDistance))*100}%,
    ${rangeColor} ${(toPosition)/(rangeDistance)*100}%, 
    ${sliderColor} ${(toPosition)/(rangeDistance)*100}%, 
    ${sliderColor} 100%)`;
}

function setToggleAccessible(currentTarget) {
  const toSlider = document.querySelector('#toSlider');
  if (Number(currentTarget.value) <= 0 ) {
    toSlider.style.zIndex = 2;
  } else {
    toSlider.style.zIndex = 0;
  }
}

function initDualRangeSlider(containerId, label, callbackFunction) {
  const container = document.querySelector(`#${containerId}`);
  if (!container) {
    console.error(`Container with ID ${containerId} not found.`);
    return;
  }

  const fromSlider = container.querySelector('#fromSlider');
  const toSlider = container.querySelector('#toSlider');
  const fromInput = container.querySelector('#fromInput');
  const toInput = container.querySelector('#toInput');

  // Update the control functions to include callback invocation
  const updateFromSlider = () => {
    controlFromSlider(fromSlider, toSlider, fromInput);
    // Invoke callback after adjusting fromSlider
    if (callbackFunction) callbackFunction(fromSlider.value, toSlider.value);
  };

  const updateToSlider = () => {
    controlToSlider(fromSlider, toSlider, toInput);
    // Invoke callback after adjusting toSlider
    if (callbackFunction) callbackFunction(fromSlider.value, toSlider.value);
  };

  const updateFromInput = () => {
    controlFromInput(fromSlider, fromInput, toInput, toSlider);
    // Invoke callback after adjusting fromInput
    if (callbackFunction) callbackFunction(fromSlider.value, toSlider.value);
  };

  const updateToInput = () => {
    controlToInput(toSlider, fromInput, toInput, toSlider);
    // Invoke callback after adjusting toInput
    if (callbackFunction) callbackFunction(fromSlider.value, toSlider.value);
  };

  // Updating the fillSlider and setToggleAccessible calls if needed
  fillSlider(fromSlider, toSlider, '#C6C6C6', '#25daa5', toSlider);
  setToggleAccessible(toSlider);

  // Attach the updated handlers to the sliders and inputs
  fromSlider.addEventListener('input', updateFromSlider);
  toSlider.addEventListener('input', updateToSlider);
  fromInput.addEventListener('input', updateFromInput);
  toInput.addEventListener('input', updateToInput);

  // Optional: Set the label if your slider has one
  if (label) {
    const containerLabel = container.querySelector('#sliderLabel');
    if (containerLabel) {
      containerLabel.textContent = label;
    }
  }
}

function configDualRangeSlider(containerId, min, max) {
    const container = document.querySelector(`#${containerId}`);
    if (!container) {
        console.error(`Container with ID ${containerId} not found.`);
        return;
    }
    
    const fromSlider = container.querySelector('#fromSlider');
    const toSlider = container.querySelector('#toSlider');
    const fromInput = container.querySelector('#fromInput');
    const toInput = container.querySelector('#toInput');

    // Update min and max for sliders
    [fromSlider, toSlider].forEach(slider => {
        slider.min = min;
        slider.max = max;
    });

    // Directly set the slider values to encompass the full range
    fromSlider.value = min;
    toSlider.value = max;

    // Update min and max for inputs and set their values
    [fromInput, toInput].forEach(input => {
        input.min = min;
        input.max = max;
    });

    fromInput.value = min;
    toInput.value = max;

    // Reapply the visual styling to the slider to reflect the new values
    fillSlider(fromSlider, toSlider, '#C6C6C6', '#25daa5', toSlider);
    setToggleAccessible(toSlider);
}
