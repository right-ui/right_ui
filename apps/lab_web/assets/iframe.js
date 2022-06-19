import './lib/alpine'
import './lib/tailwind'

import { ResizeObserver } from 'resize-observer'

function entryHeight(entry) {
  let height

  const contentBoxSize = entry.contextBoxSize

  if (contentBoxSize) {
    height = Array.isArray(contentBoxSize) ? contentBoxSize[0] : contentBoxSize
  } else {
    height = entry.contentRect.height
  }

  return height
}

window.addEventListener('load', () => {
  const resizeObserver = new ResizeObserver((entries) => {
    // there's only one body, so it's safe to do this.
    const [body, ..._] = entries

    const expectedBodyHeight = entryHeight(body)

    if (window.bodyHeight !== expectedBodyHeight && expectedBodyHeight > 0) {
      window.bodyHeight = expectedBodyHeight
    }

    window.parent.postMessage({
      type: 'BODY_HEIGHT',
      name: window.name,
      height: expectedBodyHeight,
    })
  })

  resizeObserver.observe(document.body)
})

document.addEventListener('click', (e) => {
  const target = e.target

  if (target.tagName === 'A') {
    console.log('You are clicking', target)
    return e.preventDefault()
  }
})

document.addEventListener('submit', function (e) {
  e.preventDefault()
})
