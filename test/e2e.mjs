import assert from 'node:assert/strict'
import { mkdtempSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { _setPreopens } from '@bytecodealliance/preview2-shim/filesystem'

const sandbox = mkdtempSync(join(tmpdir(), 'plugin.fs-'))
_setPreopens({ '/': sandbox })
const { fs } = await import('../build/jco/plugin.fs.js')
try {
  fs.createDir('data')
  fs.writeText('data/hello.txt', 'hello')
  assert.equal(fs.readText('data/hello.txt'), 'hello')
  assert.deepEqual([...fs.readFile('data/hello.txt')], [...new TextEncoder().encode('hello')])
  assert.equal(fs.stat('data/hello.txt').type, 'regular-file')
  assert.ok(fs.list('data').some(entry => entry.name === 'hello.txt'))
  fs.rename('data/hello.txt', 'data/world.txt')
  fs.removeFile('data/world.txt')
  fs.removeDir('data')
} finally {
  rmSync(sandbox, { recursive: true, force: true })
}
console.log('plugin.fs standalone component test: ok')
