# Packer Overwrite MOTD

Overwriting the MOTD of pre-baked AMIs using Packer

## Notes

- Message files are located in `/etc/update-motd.d/`
- Existing ones can be purged and replaced with a fixed one
- Likely want to keep the status components (source from existing, overwrite)
- Scripts need to be executable, and include shebang
- Current packer requires AWS for EC2 create/snapshot, can we avoid?

This works well for setting up a baseline for the AMIs. Is there a way we can perform this Packer construction without needing to be connected to AWS? As at the moment this more resembles "Assembly" than "Build". Having a daemon (virtualbox/hyper-v) is less optimal, but if it can be solely run on any machine with the installed tools, then that would be preferable.

Potential option is to use Virtualbox (or similar) to create an OVF file, upload to S3 and then import as an AMI using that model. That would require the build machines to have VirtualBox, but that can be worked around. This could make it so that a single server image is compatible with multiple clouds/execution environments.

What about Cloud-specific optimizations or toolchains? E.g. AWS has the CLI, Session Manager and such? Could just be a post-build, like a platform/arch specific compilation for systems.
