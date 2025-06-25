return {
	"tpope/vim-projectionist",
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"go",
		"phyton",
		"c",
	},
	config = function()
		vim.g.projectionist_heuristics = {
			-- C
			["*.{c,h}"] = {
				["*.c"] = {
					alternate = "{}.h",
					type = "source",
				},
				["*.h"] = {
					alternate = "{}.c",
					type = "header",
				},
			},

			-- Python
			["pytest.ini|Pipfile|pyproject.toml|requirements.txt|setup.cfg|setup.py|tox.ini|*.py"] = {
				["*.py"] = {
					alternate = {
						-- Test file in `tests` subdir
						"tests/test_{basename}.py",
						"tests/{dirname}/test_{basename}.py",
						-- Test file in parallel `test` dir, e.g.
						-- Source: <proj_name>/<mod>/<submod>/*.py
						-- Tests:  tests/<mod>/<submod>/test_*.py
						"tests/{dirname|tail}/test_{basename}.py",
						-- Test file for module, e.g.
						-- Source: <mod>/<submod>/*.py
						-- Tests:  <mod>/test_<submod>.py
						--         tests/<mod>/test_<submod>.py
						"tests/{dirname|dirname}/test_{dirname|basename}.py",
						"tests/{dirname|tail|dirname}/test_{dirname|basename}.py",
					},
					type = "source",
				},
				["tests/**/test_*.py"] = {
					alternate = {
						"{}.py", -- source file in parent dir
						"{}/__init__.py", -- module test
						-- Source file in parallel `src` dir
						"src/{}.py",
						"src/{}/__init__.py",
						-- Guess source file containing dir (project dir)
						-- using base of project fullpath, not always correct.
						-- Required struct:
						-- Source: [PROJECT]/<proj_name>/<mod>/<submod>/*.py
						-- Tests:  [PROJECT]/tests/<mod>/<submod>/test_*.py
						-- where [PROJECT] ends with <proj_name>
						"{project|basename}/{}.py",
						"{project|basename}/{}/__init__.py",
					},
					type = "test",
				},
			},

			-- Go
			["*.go"] = {
				["*.go"] = {
					alternate = "{}_test.go",
					type = "source",
					template = {
						"package {basename|camelcase}",
					},
				},
				["*_test.go"] = {
					alternate = "{}.go",
					type = "test",
					template = {
						"package {basename|camelcase}",
					},
				},
			},

			-- javascript
			["package.json|*.js|*.jsx|*.ts|*.tsx"] = {
				["src/*.js"] = {
					alternate = "src/{}.test.js",
					type = "source",
				},
				["src/*.test.js"] = {
					alternate = "src/{}.js",
					type = "test",
				},
				["src/*.spec.js"] = {
					alternate = "src/{}.js",
				},

				-- javascriptreact
				["src/*.jsx"] = {
					alternate = { "src/{}.spec.jsx", "src/{}.test.jsx" },
					type = "source",
				},
				["src/*.test.jsx"] = {
					alternate = "src/{}.jsx",
					type = "test",
				},
				["src/*.spec.jsx"] = {
					alternate = "src/{}.jsx",
				},

				-- typescript
				["src/*.ts"] = {
					alternate = { "src/{}.spec.ts", "src/{}.test.ts" },
					type = "source",
				},
				["src/*.test.ts"] = {
					alternate = "src/{}.ts",
					type = "test",
				},
				["src/*.spec.ts"] = {
					alternate = "src/{}.ts",
				},

				-- typescriptreact
				["src/*.tsx"] = {
					alternate = { "src/{}.spec.tsx", "src/{}.test.tsx" },
					type = "source",
				},
				["src/*.test.tsx"] = {
					alternate = "src/{}.tsx",
					type = "test",
				},
				["src/*.spec.tsx"] = {
					alternate = "src/{}.tsx",
				},
				["src/*.stories.tsx"] = {
					alternate = "src/{}.tsx",
					-- Allow :Estory to jump to alternative file eg from `Foo.tsx` to `Foo.stories.tsx`
					type = "story",
				},

				["src/*.module.css"] = {
					alternate = { "src/{}.tsx" },
					-- Allow :Estyle to jump to alternative file eg from `Foo.tsx` to `Foo.module.css`
					type = "style",
				},
			},
		}
	end,
}
